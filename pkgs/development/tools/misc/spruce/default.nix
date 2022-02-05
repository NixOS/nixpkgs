{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spruce";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "geofffranks";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HjJWiBYd1YFDZ+XOFcU2Df6bmKFBwVQ6YbiZv1IVN3A=";
  };

  deleteVendor = true;
  regenModSum = true;
  vendorSha256 = "sha256-XdOuKAxQbxpDfeErhJ0JyTZlMgO9EhBe8bXVoPUF2+Q=";

  meta = with lib; {
    description = "A BOSH template merge tool";
    homepage = "https://github.com/geofffranks/spruce";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
