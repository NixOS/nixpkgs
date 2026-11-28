{
  abseil-cpp,
  c-ares,
  cmake,
  fetchFromGitHub,
  fetchpatch,
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

mkNginxPlugin (finalAttrs: {
  pname = "otel";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-otel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pGe+1nPH8zUQhcyVxH5/nxwNFMsoOYCUecuDVs1rS4o=";
  };

  patches = [
    # Fix build with GCC16 / C++20
    (fetchpatch {
      url = "https://github.com/nginx/nginx-otel/commit/e3b6c98b1556e4c82cec39acc7be91a62449fa84.patch";
      hash = "sha256-wdV9gLfl6dETkVlo2pnA2v2iPG3jXHfAe2Zf47lqdoM=";
    })
  ];

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
    export NGX_OTEL_CMAKE_OPTS="-DNGX_OTEL_GRPC=package -DNGX_OTEL_SDK=package -DNGX_OTEL_PROTO_DIR=${opentelemetry-cpp.opentelemetry-proto} -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=$out/modules"
  '';

  passthru = {
    # cmake's setup hook would replace nginx's configurePhase.
    forNginx.dontUseCmakeConfigure = true;

    tests = { inherit (nixosTests.nginx.stable) otel; };
  };

  meta = {
    description = "OpenTelemetry support for nginx";
    homepage = "https://github.com/nginxinc/nginx-otel";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
