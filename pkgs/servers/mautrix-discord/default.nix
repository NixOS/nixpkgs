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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-rs7wWlQMc79Vls+cqPPo+lRzYAGye4WcKKz+9EXlEBo=";
  };

  vendorHash = "sha256-ZI1+Tfru2OfnqLnaaiDL08OtSmbMBiRDvkL39+jhhmI=";

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
