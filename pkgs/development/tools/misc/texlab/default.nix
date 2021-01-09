{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hiy8klig7j0if4iqbb0432iqsnds00aya6p4xmm913qfpsyh6cq";
  };

  cargoSha256 = "0pf8j202rpglcxamsr8r3wwmgsdgih24m52vh1q85l93vj7jkm1v";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage texlab.1
  '';

  meta = with lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://texlab.netlify.app";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
  };
}
