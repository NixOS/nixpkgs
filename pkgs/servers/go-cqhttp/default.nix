{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-cqhttp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Mrs4s";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/nmPiB2BHltguAJFHCvtS3oh/BttEH75GhgSa25cI3s=";
  };

  vendorHash = "sha256-Oqig/qtdGFO2/t7vvkApqdNhjNnYzEavNpyneAMa10k=";

  meta = with lib; {
    description = "The Golang implementation of OneBot based on Mirai and MiraiGo";
    homepage = "https://github.com/Mrs4s/go-cqhttp";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Anillc ];
  };
}
