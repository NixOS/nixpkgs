{ stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cmciadiknw6w573v71spzf5ydaz2xxm2snv3n1hks732nahlr56";
  };

  cargoSha256 = "0dhbbni8ia0dkwjacx5jlr5rj7173nsbivm9gjsx9j8ais0f0hff";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://texlab.netlify.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
    platforms = platforms.all;
  };
}
