{
  abseil-cpp,
  c-ares,
  cmake,
  fetchFromGitHub,
  grpc,
  lib,
  nixosTests,
  nlohmann_json,
  openssl,
  opentelemetry-cpp,
  pkg-config,
  protobuf,
  re2,
  zlib,
  stdenv,
  nginx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "otel";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-otel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pGe+1nPH8zUQhcyVxH5/nxwNFMsoOYCUecuDVs1rS4o=";
  };

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
    nginx
  ] ++ nginx.buildInputs;

  strictDeps = true;

  cmakeFlags = [
    "-DNGX_OTEL_GRPC=package"
    "-DNGX_OTEL_SDK=package"
    "-DNGX_OTEL_PROTO_DIR=${opentelemetry-cpp.opentelemetry-proto}"
    "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${placeholder "out"}/modules"
  ];

  dontInstall = true;

  passthru = {
    tests = { inherit (nixosTests.nginx.stable) otel; };
  };

  meta = {
    description = "OpenTelemetry support for nginx";
    homepage = "https://github.com/nginxinc/nginx-otel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
