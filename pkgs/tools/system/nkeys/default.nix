{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nkeys";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ui/vSa2TGe6Pe2aAzitBa1Pd2vKgTMuHoBhYYy2p6Rw=";
  };

  vendorHash = "sha256-SiSqmj6ktfiGsJOSu/pBY53e3vnN+RBfTkGwUuW52uo=";

  meta = with lib; {
    description = "Public-key signature system for NATS";
    homepage = "https://github.com/nats-io/nkeys";
    changelog = "https://github.com/nats-io/nkeys/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nk";
  };
}
