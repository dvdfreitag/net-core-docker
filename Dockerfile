FROM ubuntu:14.04

# Install wget
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/list/*

# Add package source for lldb
RUN echo "deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.6 main" | sudo tee /etc/apt/sources.list.d/llvm.list && \
			wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -

# Install dependencies
RUN apt-get update && apt-get install -y \
			git \
			cmake \
			llvm-3.5 \
			clang-3.5 \
			lldb-3.6 \
			lldb-3.6-dev \
			libunwind8 \
			libunwind8-dev \
			gettext libicu-dev \
			liblttng-ust-dev \
			libcurl4-openssl-dev \
			libssl-dev \
			uuid-dev \
			&& rm -rf /var/lib/apt/list/*

# Clone repositories
RUN git clone https://github.com/dotnet/coreclr.git && git clone https://github.com/dotnet/corefx.git

# Build the runtime and the core library
RUN cd coreclr && ./build.sh

# Transfer build outputs to shared folder
RUN mkdir -p /build-output/coreclr && \
			cp coreclr/bin/Product/Linux.x64.Debug/corerun /build-output/coreclr && \
			cp coreclr/bin/Product/Linux.x64.Debug/libcoreclr.so /build-output/coreclr && \
			cp coreclr/bin/Product/Linux.x64.Debug/mscorlib.dll /build-output/coreclr

# Build the framework
RUN cd corefx && ./build.sh

# Transfer the build outputs to shared folder
RUN mkdir -p /build-output/corefx && \
			cp -R bin/ /build-output/corefx
