{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "vinegar";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "vinegarhq";
    repo = "vinegar";
    rev = "v${version}";
    hash = "sha256-tKVfCUXpYEiuwk8eD9/9PzTLtRJ7Z75oa/Ht1YxdLBY=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "An open-source, minimal, configurable, fast bootstrapper for running Roblox on Linux";
    homepage = "https://github.com/vinegarhq/vinegar";
    changelog = "https://github.com/vinegarhq/vinegar/releases/tag/v${version}";
    mainProgram = "vinegar";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
