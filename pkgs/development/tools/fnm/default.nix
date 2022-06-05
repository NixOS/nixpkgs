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
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8A6MKDeyuk0bzyoDydcOy4LzyYe/S+x+ZJMTOo59UA8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation Security ];

  cargoSha256 = "sha256-oiGYkRqxN6e5EG6EDQalIK0tOekyIVQ+GhxCKK0Sd3g=";

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
