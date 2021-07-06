{ lib, buildGoModule, fetchFromGitHub, terraform }:

buildGoModule rec {
  pname = "infracost";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-TM+7Am5hoiRk/StAwCh5yAN1GKv3oPun38pvhArBoJg=";
  };

  vendorSha256 = "sha256-6sMtM7MTFTDXwH8AKr5Dxq8rPqE92xzcWqBTixcPi+8=";

  checkInputs = [ terraform ];
  checkPhase = "make test";

  meta = with lib; {
    description = "Cloud cost estimates for Terraform in your CLI and pull requests";
    homepage = "https://github.com/infracost/infracost";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.davegallant ];
  };
}
