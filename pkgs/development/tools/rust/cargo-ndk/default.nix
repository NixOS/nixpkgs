{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "2.12.6";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VGdFIMyZhb7SDWAXgs7kFlblYCO4rLf+3/N7Mashc4o=";
  };

  cargoHash = "sha256-pv6t9oKj5tdQjpvBgj/Y11uKJIaIWcaA9ib/Id/s+qs=";

  meta = with lib; {
    description = "Cargo extension for building Android NDK projects";
    homepage = "https://github.com/bbqsrc/cargo-ndk";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ mglolenstine ];
    platforms = platforms.linux;
  };
}

