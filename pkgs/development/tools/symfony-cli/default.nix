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
  version = "5.8.2";
  vendorHash = "sha256-bscRqFYV2qzTmu04l00/iMsFQR5ITPBFVr9BQwVGFU8=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    hash = "sha256-P5VitZL6KYplMpWdwTkzJEqf5UoSB5HaH/0kL2CbUEA=";
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
