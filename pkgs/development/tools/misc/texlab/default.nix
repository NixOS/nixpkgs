{ stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "12zfcvbihirh38xxzc8fbx293m4vsrhq6kh0qnhnhlrx75m09l9i";
  };

  cargoSha256 = "08fi0c4s0d1p2rqxvj1y82zg6xl3n0ikgyhgrjwh6xay8f0121f0";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = https://texlab.netlify.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
    platforms = platforms.all;
  };
}
