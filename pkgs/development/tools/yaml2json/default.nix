{ stdenv, buildGoPackage, fetchFromGitHub }:


buildGoPackage rec {
  pname = "yaml2json";
  version = "unstable-2017-05-03";
  goPackagePath = "github.com/bronze1man/yaml2json";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    rev = "ee8196e587313e98831c040c26262693d48c1a0c";
    owner = "bronze1man";
    repo = "yaml2json";
    sha256 = "16a2sqzbam5adbhfvilnpdabzwncs7kgpr0cn4gp09h2imzsprzw";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/bronze1man/yaml2json;
    description = "Convert yaml to json";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
