{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gops";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${version}";
    sha256 = "091idnsgbwabmm5s9zhm474fbxvjvpkvwg68snbypfll7wdr3phy";
  };

  vendorSha256 = null;

  preCheck = "export HOME=$(mktemp -d)";

  meta = with lib; {
    description = "A tool to list and diagnose Go processes currently running on your system";
    homepage = "https://github.com/google/gops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pborzenkov ];
  };
}
