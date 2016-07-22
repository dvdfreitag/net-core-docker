# net-core-docker

This Dockerfile generates a docker image that contains the build outputs of https://github.com/dotnet/coreclr and https://github.com/dotnet/corefx.

All of the necessary dependencies are installed, then the builds are initiated. Once the builds have finished, the outputs are copied to `/build-output` inside of the image so that they can be `docker cp`'d out.
