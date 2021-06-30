{ lib, buildGoModule, fetchFromGitHub, terraform }:

buildGoModule rec {
  pname = "infracost";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-3dR4NZ1PiMuHNO+xl3zxeBLPOZTLAbJ0VtYJNYpJuXI=";
  };

  vendorSha256 = "sha256-YHewZsIiDPsgJVYwQX/FovlD+UzJflXy/0oglk8ZkKk=";

  checkInputs = [ terraform ];
  checkPhase = "make test";

  meta = with lib; {
    description = "Cloud cost estimates for Terraform in your CLI and pull requests";
    homepage = "https://github.com/infracost/infracost";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.davegallant ];
  };
}
