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

  cargoSha256 = "1w0q5w0bf1682jvzcml8cgmr9mrgi4if0p63wzchyjav330dp6pk";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Colourise your checksum output";
    homepage = "https://github.com/ticky/coloursum";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}
