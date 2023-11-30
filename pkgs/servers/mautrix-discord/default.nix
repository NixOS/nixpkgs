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
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-p2DQD2E9RmP6yZGD88Y15eTz06euhNDaxCnnrWzqaB4=";
  };

  vendorHash = "sha256-rbz6bWBl2rmfHuszjKoWZP4/B4F90MUtR5nAIXCU3pg=";

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
    mainProgram = "mautrix-discord";
  };
}
