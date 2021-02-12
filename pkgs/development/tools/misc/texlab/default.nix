{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "06x7j4ppgw24xbsnyj1icaksngqbvq6mk8wfcqikzmvmifjspx9m";
  };

  cargoSha256 = "0cimyxlidl87qqfspmhxqljyzxsylwwx9a47r5blmfsczlhpw8ma";

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
