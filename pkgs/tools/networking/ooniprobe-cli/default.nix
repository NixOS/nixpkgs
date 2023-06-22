{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-3KnPqUB9vNxIWF28BGZqqg1IwglHOP2qAZfDMaNcN7s=";
  };

  vendorHash = "sha256-iMEmTip9c7ySFUxcKr8ZUuREw7FfBvsIhECvmagvVL0=";

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
