FROM public.ecr.aws/amazonlinux/amazonlinux:latest as root

RUN yum install deltarpm -y
RUN yum update -y
RUN yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
RUN yum install ncurses-libs openssl-libs flex java-1.8.0-openjdk libxslt fop -y

ENV LANG=c.UTF-8
ENV LC_COLLATE="en_US.UTF-8"
ENV LC_CTYPE="en_US.UTF-8"
ENV LC_MESSAGES="en_US.UTF-8"
ENV LC_MONETARY="en_US.UTF-8"
ENV LC_NUMERIC="en_US.UTF-8"
ENV LC_TIME="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV ELIXIR_VERSION="v1.13.1"
ENV OTP_VERSION="OTP-24.3.2"

FROM root as buildelixir

RUN yum install git perl ncurses-devel openssl-devel flex-devel java-1.8.0-openjdk-devel libxslt-devel sed -y
RUN yum groupinstall "Development Tools" -y
RUN git clone https://github.com/erlang/otp.git erlang
RUN git clone https://github.com/elixir-lang/elixir.git

ENV ERL_TOP=/erlang
WORKDIR /erlang
RUN git checkout $OTP_VERSION
RUN ./configure --prefix=/opt/erlang
RUN make
RUN make release_tests
WORKDIR /erlang/release/tests/test_server
RUN /erlang/bin/erl -s ts install -s ts smoke_test batch -s init stop
WORKDIR /erlang
RUN make install

ENV PATH="$PATH:/opt/erlang/bin:/opt/erlang/lib"
WORKDIR /elixir
RUN git checkout ${ELIXIR_VERSION}
RUN make clean test
RUN make install PREFIX=/opt/elixir

FROM root

COPY --from=buildelixir /opt/erlang /opt/erlang
COPY --from=buildelixir /opt/elixir /opt/elixir
ENV PATH="$PATH:/opt/erlang/bin:/opt/erlang/lib:/opt/elixir/bin:/opt/elixir/lib"
RUN mix local.hex --force
RUN epmd -daemon
