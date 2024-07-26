{ lib
, callPackage
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, protobuf
, elfutils
}:

rustPlatform.buildRustPackage rec {
  pname = "router";
  version = "1.51.0";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-U2CL+RwCtDcRdK2DMpcqXEDJvOfYiYWT7IEqTO5ykNk=";
  };

  cargoHash = "sha256-TwVA17/fKmhV3/xmQUopqel5pQ6aF2ew9q90a/aky/o=";

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
  ];

  buildInputs = [
    elfutils
  ];

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = callPackage ./librusty_v8.nix { };

  cargoTestFlags = [
    "-- --skip=query_planner::tests::missing_typename_and_fragments_in_requires"
  ];

  meta = with lib; {
    description = "Configurable, high-performance routing runtime for Apollo Federation";
    homepage = "https://www.apollographql.com/docs/router/";
    license = licenses.elastic20;
    maintainers = [ maintainers.bbigras ];
  };
}
