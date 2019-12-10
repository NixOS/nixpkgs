{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "awsweeper";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "cloudetc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0if2sfxd28m832zyiy40grwa4may45zq20h35yxf8bq0wxvp0q3f";
  };

  modSha256 = "0nzc8ib2c3wlwk97qq45kgpnval69v8nbxhkfabcx0idipx3pbvk";

  meta = with lib; {
    description = "A tool to clean out your AWS account";
    homepage = "https://github.com/cloudetc/awsweeper/";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
