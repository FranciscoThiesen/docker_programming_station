FROM ubuntu:22.04
 ARG USER_NAME
 ARG USER_ID
 ARG GROUP_ID
# We install some useful packages
 RUN apt-get update -qq
 RUN apt-get install -y vim ninja-build valgrind curl llvm gdb clang-format sudo python3 python3-dev wget cmake g++ g++-12 libcurl4-openssl-dev libicu-dev clang-14 clang libboost-all-dev git  linux-tools-generic hyperfine
 RUN addgroup --gid $GROUP_ID user; exit 0
 RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID $USER_NAME; exit 0
 RUN echo "$USER_NAME:$USER_NAME" | chpasswd && adduser $USER_NAME sudo
 RUN echo '----->'
 RUN echo 'root:Docker!' | chpasswd
 ENV TERM xterm-256color
 USER $USER_NAME
 RUN gcc --version
 RUN cmake --version
