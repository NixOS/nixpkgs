{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "kestrel";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "finfet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-n0XIFBCwpc6QTj3PjGp+fYtU4U+RAfA4PRcettFlxVA=";
  };

  cargoHash = "sha256-GZK4IaAolU1up2bYd/2tBahcCP70hO5/shDODUD+aRE=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage docs/man/kestrel.1
    installShellCompletion --bash --name ${pname} completion/kestrel.bash-completion
  '';

  meta = with lib; {
    description = "File encryption done right";
    longDescription = "
      Kestrel is a data-at-rest file encryption program
      that lets you encrypt files to anyone with a public key.
    ";
    homepage = "https://getkestrel.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zendo ];
  };
}
