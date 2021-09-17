{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spruce";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cNO+6rMQPO1e4Hen8vcFU1FRnnCv2+fDYtXXbuR2UCU=";
  };

  deleteVendor = true;
  vendorSha256 = "sha256-5EM4Z9AN1Mjy7DayII0Iu+XrjM9lyUqrScMT/fe43dw=";

  meta = with lib; {
    description = "A BOSH template merge tool";
    homepage = "https://github.com/geofffranks/spruce";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
