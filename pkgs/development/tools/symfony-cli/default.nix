{ buildGoModule
, fetchFromGitHub
, lib
, nix-update-script
, testers
, symfony-cli
, nssTools
, makeBinaryWrapper
}:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.8.0";
  vendorHash = "sha256-JIvMW12q5RySBP6b1k178N8V8XFCaTEJj/XslqbxcpA=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    hash = "sha256-X85hPwnn7UnadhPolS8gwC+KYvJMZXOo3Dy72I2f2Q4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.channel=stable"
  ];

  buildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    mkdir $out/libexec
    mv $out/bin/symfony-cli $out/libexec/symfony

    makeBinaryWrapper $out/libexec/symfony $out/bin/symfony \
      --prefix PATH : ${lib.makeBinPath [ nssTools ]}
  '';

  # Tests requires network access
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = symfony-cli;
      command = "symfony version --no-ansi";
    };
  };

  meta = {
    changelog = "https://github.com/symfony-cli/symfony-cli/releases/tag/v${version}";
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = lib.licenses.agpl3Plus;
    mainProgram = "symfony";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
