{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gops";
  version = "0.3.28";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${version}";
    sha256 = "sha256-HNM487WSfNWNF31ccDIdotsEG8Mj2C7V85UI47a9drU=";
  };

  vendorHash = "sha256-ptC2G7cXcAjthJcAXvuBqI2ZpPuSMBqzO+gJiyaAUP0=";

  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    description = "Tool to list and diagnose Go processes currently running on your system";
    mainProgram = "gops";
    homepage = "https://github.com/google/gops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pborzenkov ];
  };
}
