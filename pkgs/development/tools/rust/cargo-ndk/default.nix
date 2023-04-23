{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fPN5me8+KrnFR0NkWVxWm8OXZbObUWsYKChldme0qyc=";
  };

  cargoHash = "sha256-UEQ+6N7D1/+vhdzYthcTP1YuVEmo5llrpndKuwmrjKc=";

  meta = with lib; {
    description = "Cargo extension for building Android NDK projects";
    homepage = "https://github.com/bbqsrc/cargo-ndk";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ mglolenstine ];
    platforms = platforms.linux;
  };
}

