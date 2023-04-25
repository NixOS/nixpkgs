{ lib
, callPackage
, fetchFromGitHub
, rustPlatform
, pkg-config
, protobuf
, elfutils
}:

rustPlatform.buildRustPackage rec {
  pname = "router";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xekMw0StdCSI3tls0D2I5rqRV8fVtecGSEzlB3ao6zY=";
  };

  cargoSha256 = "sha256-F9MomJQShJUE9QIJJmdFxSs/FVctig17ZclndFl1SUY=";

  nativeBuildInputs = [
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
    "-- --skip=uplink::test::stream_from_uplink_error_no_retry"
  ];

  meta = with lib; {
    description = "A configurable, high-performance routing runtime for Apollo Federation";
    homepage = "https://www.apollographql.com/docs/router/";
    license = licenses.elastic;
    maintainers = [ maintainers.bbigras ];
  };
}
