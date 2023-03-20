{ lib, buildGoPackage, fetchFromGitHub }:


buildGoPackage rec {
  pname = "yaml2json";
  version = "1.3";
  goPackagePath = "github.com/bronze1man/yaml2json";

  src = fetchFromGitHub {
    owner = "bronze1man";
    repo = "yaml2json";
    rev = "v${version}";
    sha256 = "0bhjzl4qibiyvn56wcsm85f3vwnlzf4gywy2gq9mrnbrl629amq1";
  };

  meta = with lib; {
    homepage = "https://github.com/bronze1man/yaml2json";
    description = "Convert yaml to json";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.adisbladis ];
  };
}
