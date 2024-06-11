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
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ruEv46jzO79l2Nvs3UjWHal2lBmhjdIKC99va/2cGio=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation Security ];

  cargoHash = "sha256-ez6rzmVa/eRcd4bdCM4JEaNILpavub34kaonX4BRjW8=";

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd fnm \
      --bash <($out/bin/fnm completions --shell bash) \
      --fish <($out/bin/fnm completions --shell fish) \
      --zsh <($out/bin/fnm completions --shell zsh)
  '';

  meta = with lib; {
    description = "Fast and simple Node.js version manager";
    mainProgram = "fnm";
    homepage = "https://github.com/Schniz/fnm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kidonng ];
  };
}
