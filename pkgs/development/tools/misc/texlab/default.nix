{ stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab-unwrapped";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y8cv8y92a4nqwrvqk2cxgs6nspqjk8jm4spr8rgkwlpfbrg74xn";
  };

  cargoSha256 = "1cxi6bvdyhxb5jnw5dhba5mdsc149cw6mzaf00ayvc4pcdrj323s";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://texlab.netlify.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
    platforms = platforms.all;
  };
}
