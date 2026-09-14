{
  abseil-cpp,
  c-ares,
  cmake,
  fetchFromGitHub,
  grpc,
  lib,
  mkNginxPlugin,
  nixosTests,
  nlohmann_json,
  openssl,
  opentelemetry-cpp,
  pkg-config,
  protobuf,
  re2,
  zlib,
}:

let
  # Same revision opentelemetry-cpp builds against.
  opentelemetry-proto = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-proto";
    rev = "v1.10.0";
    hash = "sha256-RJrS0C4GZfUdETff+ZlbJr67Z+JObrLsDvyGqobf4UI=";
  };
in

mkNginxPlugin (finalAttrs: {
  pname = "otel";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-otel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pGe+1nPH8zUQhcyVxH5/nxwNFMsoOYCUecuDVs1rS4o=";
  };

  # nginx-otel can only be loaded dynamically.
  dynamic = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    grpc
  ];

  buildInputs = [
    grpc
    protobuf
    opentelemetry-cpp
    c-ares
    re2
    abseil-cpp
    nlohmann_json
    openssl
    zlib
  ];

  # Read by the module's config script. nginx's install step does not know
  # about the cmake-built .so, so cmake writes it into the modules dir itself.
  preConfigure = ''
    export NGX_OTEL_CMAKE_OPTS="-DNGX_OTEL_GRPC=package -DNGX_OTEL_SDK=package -DNGX_OTEL_PROTO_DIR=${opentelemetry-proto} -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=$out/modules"
  '';

  passthru.tests = {
    inherit (nixosTests) nginx-otel;
  };

  meta = {
    description = "OpenTelemetry support for nginx";
    homepage = "https://github.com/nginxinc/nginx-otel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
