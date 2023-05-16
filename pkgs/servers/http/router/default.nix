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
<<<<<<< HEAD
  version = "1.19.0";
=======
  version = "1.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "apollographql";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-IuS7NmlTNmHHnnSZ+YIbV6BnxJW2xprOQ5mkz5FuJEQ=";
  };

  cargoHash = "sha256-yeb+4lgRDssjkEx6bYfGIbn4DJGpZZ/JDmuwFjQ+U+8=";
=======
    sha256 = "sha256-PJEXsICqoc/9UHlQbXwQgf7IlZCWW0I87mThevnIMZQ=";
  };

  cargoSha256 = "sha256-0/KA5i1DRvXT5DVzhrEtyxpNFd637IXHQgo36a+08FA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
