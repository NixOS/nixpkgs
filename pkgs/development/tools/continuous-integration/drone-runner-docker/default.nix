{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "drone-runner-docker";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "drone-runners";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WI3pr0t6EevIBOQwCAI+CY2O8Q7+W/CLDT/5Y0+tduQ=";
  };

  vendorSha256 = "15lpdliqz129yq5zgzjvndwdxngxa96g0ska4zkny7ycb3vwq0xm";

  meta = with lib; {
    maintainers = with maintainers; [ endocrimes ];
    license = licenses.unfreeRedistributable;
    homepage = "https://github.com/drone-runners/drone-runner-docker";
    description = "Drone pipeline runner that executes builds inside Docker containers";
  };
}
