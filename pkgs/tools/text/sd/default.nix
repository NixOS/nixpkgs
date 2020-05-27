{ stdenv, fetchFromGitHub, rustPlatform, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "sd";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "04jsni80jzhbb106283df34cdyp5p362l6m29kp30hnc6x49853q";
  };

  cargoSha256 = "1gwb76zys7gky42clzjs5g4hhgpfvzcw63chw9mnj703c7h0cgfh";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative)";
    homepage = "https://github.com/chmln/sd";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ amar1729 filalex77 ];
  };
}
