
# Stage 1. Check out LLVM source code and run the build.
FROM debian:12 as builder
# First, Update the apt's source list and include the sources of the packages.
RUN grep deb /etc/apt/sources.list | \
    sed 's/^deb/deb-src /g' >> /etc/apt/sources.list
# Install compiler, python and subversion.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates gnupg \
           build-essential cmake make python3 zlib1g wget subversion unzip git && \
    rm -rf /var/lib/apt/lists/*
# Install a newer ninja release. It seems the older version in the debian repos
# randomly crashes when compiling llvm.
RUN wget "https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip" && \
    echo "d2fea9ff33b3ef353161ed906f260d565ca55b8ca0568fa07b1d2cab90a84a07 ninja-linux.zip" \
        | sha256sum -c  && \
    unzip ninja-linux.zip -d /usr/local/bin && \
    rm ninja-linux.zip

RUN git clone --depth=1 --branch p2996  https://github.com/bloomberg/clang-p2996.git /tmp/clang-source
RUN cmake -G "Ninja" -S /tmp/clang-source/llvm -B /tmp/clang-source/build-llvm -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_UNREACHABLE_OPTIMIZE=ON \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
    -DLLVM_ENABLE_PROJECTS=clang
RUN cmake --build /tmp/clang-source/build-llvm -j
RUN cmake --install /tmp/clang-source/build-llvm --prefix /tmp/clang-install


# Stage 2. Produce a minimal release image with build results.
FROM debian:12
LABEL maintainer "LLVM Developers"
# Install packages for minimal useful image.
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential cmake make python3 python3-dev sudo curl ninja-build vim git binutils && \
    rm -rf /var/lib/apt/lists/*
# Copy build results of stage 1 to /usr/local.
COPY --from=builder /tmp/clang-install/ /usr/local/