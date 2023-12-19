{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.20.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-kOARV3tnRyOAScc3Vn96TFQFgqvTgi6NFHWM7ZbpciU=";
  };

  vendorHash = "sha256-c922VpxtpNfua3Sx3vXKz4x1FsLMwbaSvRH4dyFrr9s=";

  subPackages = [ "cmd/ooniprobe" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${src.rev}";
    description = "The Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
