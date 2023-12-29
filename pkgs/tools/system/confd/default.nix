{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "confd";
  version = "0.16.0";
  rev = "v${version}";

  goPackagePath = "github.com/kelseyhightower/confd";
  subPackages = [ "./" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "kelseyhightower";
    repo = "confd";
    sha256 = "0q7r6dkgirnmqi3rhqdaai88jqzw52l6jdrrwsf2qq0hva09961p";
  };

  meta = {
    description = "Manage local application configuration files using templates and data from etcd or consul";
    homepage = "https://github.com/kelseyhightower/confd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimbatm ];
    mainProgram = "confd";
  };
}
