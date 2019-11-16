{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "coloursum";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ticky";
    repo = "coloursum";
    rev = "v${version}";
    sha256 = "1piz0l7qdcvjzfykm6rzqc8s1daxp3cj3923v9cmm41bc2v0p5q0";
  };

  cargoSha256 = "091flc5ymx0y43ld6bdmig5cy479b90bkmwv3yaysi5kpr28skvh";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Colourise your checksum output";
    homepage = "https://github.com/ticky/coloursum";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}
