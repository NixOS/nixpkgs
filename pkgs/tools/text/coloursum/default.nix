{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "coloursum";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ticky";
    repo = "coloursum";
    rev = "v${version}";
    sha256 = "1piz0l7qdcvjzfykm6rzqc8s1daxp3cj3923v9cmm41bc2v0p5q0";
  };

  cargoSha256 = "1hk81aq1251fz8l3ps2026132z4iil1xxzcizjh414mp7qd43b26";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Colourise your checksum output";
    homepage = "https://github.com/ticky/coloursum";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
