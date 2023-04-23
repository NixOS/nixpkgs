{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.17.1";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-2BsgSsIIQPzqTfoAunBkwrshZd22aI/AXFfz2tk3/78=";
  };

  vendorHash = "sha256-r8kyL9gpdDesY8Mbm4lONAhWC4We26Z9uG7QMt1JT9c=";

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
