{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "kestrel";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "finfet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kEM81HIfWETVrUiqXu1+3az+Stg3GdjHE7FaxXJgNYk=";
  };

  cargoHash = "sha256-xv35oFawFLVXZS3Eum6RCo8LcVvHftfv+UvJYYmIDx4=";

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
