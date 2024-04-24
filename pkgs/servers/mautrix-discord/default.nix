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
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "v${version}";
    hash = "sha256-kjIBjkRI0BrbMNkb1Tdv7d+ZFOKRkUL9KxtQMtvxpIM=";
  };

  vendorHash = "sha256-qRIgdkDp1pd/bA/AIU4PvoXcvrQam0kmr0hu4yAl+IY=";

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
