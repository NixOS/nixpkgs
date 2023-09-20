{ lib
, buildGoModule
, fetchFromGitHub
, olm
, nix-update-script
, testers
, mautrix-discord
}:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-194AB7r63gijTyeh8mn5N/AgVBeh39YMwdmvuAi3c9k=";
  };

  vendorHash = "sha256-389ewqgpdFNRGAyka+oumx0RVadCSt1BXsXxIGTQwW0=";

  ldflags = [ "-s" "-w" ];

  buildInputs = [ olm ];

  doCheck = false;


  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = mautrix-discord;
    };
  };

  meta = with lib; {
    description = "A Matrix-Discord puppeting bridge";
    homepage = "https://github.com/mautrix/discord";
    changelog = "https://github.com/mautrix/discord/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ MoritzBoehme ];
  };
}
