{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, DiskArbitration
, Foundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fnm";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8/J7LfSk2a0Bq9v6CH63BIyUkT56EY+4UcEUdwkbZ4U=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation Security ];

  cargoSha256 = "sha256-k3WZpN6DSbFFKLilFEN2lDMbJH5q1KgfE12OoGv+eGk=";

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd fnm \
      --bash <($out/bin/fnm completions --shell bash) \
      --fish <($out/bin/fnm completions --shell fish) \
      --zsh <($out/bin/fnm completions --shell zsh)
  '';

  meta = with lib; {
    description = "Fast and simple Node.js version manager";
    homepage = "https://github.com/Schniz/fnm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kidonng ];
  };
}
