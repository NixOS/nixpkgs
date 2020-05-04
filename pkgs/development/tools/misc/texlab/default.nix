{ stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y8cv8y92a4nqwrvqk2cxgs6nspqjk8jm4spr8rgkwlpfbrg74xn";
  };

  cargoSha256 = "1qi1c4v5d5a4xcf1bjbdicrv35w6chl5swlm96c1h3pr9s09lqy7";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://texlab.netlify.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
    platforms = platforms.all;
  };
}
