{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ooniprobe-cli";
  version = "3.21.1";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    rev = "v${version}";
    hash = "sha256-H5QlyxNQdKGoTIdfh/neULakTddVIhXgMJ/wLbqvGbY=";
  };

  vendorHash = "sha256-I88cALmc8iTaVJ36ntQLw+wRMM2GLWMWLhv8EDJDRgg=";

  subPackages = [ "cmd/ooniprobe" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${src.rev}";
    description = "The Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
}
