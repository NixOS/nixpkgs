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
  version = "1.38.0";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lPIQHgDPKbTAhAeBzu3zQV/jdMtSc+oh0FXX5NbBhI8=";
  };

  cargoHash = "sha256-5uOpITx1EGOeKml51zH3SKkBJ6KaA/UAwOvAey5Hd24=";

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

  doCheck = false;
  cargoTestFlags = [
    "-- --skip=uplink::test::stream_from_uplink_error_no_retry"
  ];

  meta = with lib; {
    description = "A configurable, high-performance routing runtime for Apollo Federation";
    homepage = "https://www.apollographql.com/docs/router/";
    license = licenses.elastic20;
    maintainers = [ maintainers.bbigras ];
  };
}
