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
  version = "1.31.1";

  src = fetchFromGitHub {
    owner = "Schniz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5DonN9tzap3mMu6/WS5evXtOjpRg4g80evCaSOsTgQA=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation Security ];

  cargoSha256 = "sha256-E4Zbk3+fbjZMXRxBcTn9S8XMSts+5m78UIP33oZOsXQ=";

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
