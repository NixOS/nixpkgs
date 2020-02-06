{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mustache-go";
  version = "1.0.1";

  goPackagePath = "github.com/cbroglie/mustache";

  src = fetchFromGitHub {
    owner = "cbroglie";
    repo = "mustache";
    rev = "v${version}";
    sha256 = "1aywj4fijsv66n6gjiz3l8g1vg0fqzwbf8dcdcgfsvsdb056p90v";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/cbroglie/mustache;
    description = "The mustache template language in Go";
    license = [ licenses.mit ];
    maintainers = [ maintainers.Zimmi48 ];
  };
}
