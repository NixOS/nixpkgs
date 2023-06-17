{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.17.3";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-kqjTYowAEfJ+um9DQQXIMLVWlEGJ9intbdTSJukSvVc=";
  };

  vendorHash = "sha256-kS5HWiATn2WT6E5gb0Gve83hHJ++xHmPSsgJu/5GqO4=";

  subPackages = [ "cmd/ooniprobe" ];

  meta = with lib; {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${src.rev}";
    description = "The Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
