{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "kestrel";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "finfet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-l9YYzwyi7POXbCxRmmhULO2YJauNJBfRGuXYU3uZQN4=";
  };

  cargoHash = "sha256-XqyFGxTNQyY1ryTbL9/9s1WVP4bVk/zbG9xNdddLX10=";

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
