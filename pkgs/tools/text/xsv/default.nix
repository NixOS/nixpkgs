{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "xsv";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "xsv";
    rev = version;
    sha256 = "17v1nw36mrarrd5yv4xd3mpc1d7lvhd5786mqkzyyraf78pjg045";
  };

  cargoHash = "sha256-y9f9eBMhSBx6L3cZyZ4VkNSB7yJ55khCskUp6t4HBq4=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Fast CSV toolkit written in Rust";
    mainProgram = "xsv";
    homepage = "https://github.com/BurntSushi/xsv";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = [ maintainers.jgertm ];
  };
}
