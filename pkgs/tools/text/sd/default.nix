{ stdenv, fetchFromGitHub, rustPlatform, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = version;
    sha256 = "1vxljmd1vh245yhv095i3l44pk915zr2pix4v9r8pz2fynp2nnmj";
  };

  cargoSha256 = "1shqphbpn3ib28hnyib7mh1i5q56nshj864jm209s8qggbp96wp1";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.amar1729 ];
  };
}
