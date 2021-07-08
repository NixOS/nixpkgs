{ lib, buildGoModule, fetchFromGitHub, terraform }:

buildGoModule rec {
  pname = "infracost";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "infracost";
    rev = "v${version}";
    repo = "infracost";
    sha256 = "sha256-3AH/VUKIno/jObep5GNfIpyOW5TcfZ5UZyornJWTGOw=";
  };

  vendorSha256 = "sha256-zMEtVPyzwW4SrbpydDFDqgHEC0/khkrSxlEnQ5I0he8=";

  checkInputs = [ terraform ];
  checkPhase = "make test";

  meta = with lib; {
    description = "Cloud cost estimates for Terraform in your CLI and pull requests";
    homepage = "https://github.com/infracost/infracost";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.davegallant ];
  };
}
