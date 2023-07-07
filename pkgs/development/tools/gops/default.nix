{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gops";
  version = "0.3.27";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${version}";
    sha256 = "sha256-F1/1wMO2lQ4v2+r3FPzaxCkL2lW+COgxy4fjv6+p7AY=";
  };

  vendorHash = "sha256-ea+1AV0WzaQiDHyAUsm0rd/bznehG9UtmB1ubgHrOGM=";

  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    description = "A tool to list and diagnose Go processes currently running on your system";
    homepage = "https://github.com/google/gops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pborzenkov ];
  };
}
