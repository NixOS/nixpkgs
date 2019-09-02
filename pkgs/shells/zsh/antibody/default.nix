{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "antibody";
  version = "4.1.2";

  goPackagePath = "github.com/getantibody/antibody";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "1csanmvix7b2sa7nsy8nh3jq6gmhp8i51xivsabm1lj2y30c0ly3";
  };

  modSha256 = "1p9cw92ivwgpkvjxvwd9anbd1vzhpicm9il4pg37z2kgr2ihhnyh";

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = https://github.com/getantibody/antibody;
    license = licenses.mit;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
