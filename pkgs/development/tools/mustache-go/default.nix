{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "mustache-go";
  version = "1.2.0";

  goPackagePath = "github.com/cbroglie/mustache";

  src = fetchFromGitHub {
    owner = "cbroglie";
    repo = "mustache";
    rev = "v${version}";
    sha256 = "0mnh5zbpfwymddm1dppg9i9d1r8jqyg03z2gl6c5a8fgbrnxpjvc";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/cbroglie/mustache";
    description = "The mustache template language in Go";
    license = [ licenses.mit ];
    maintainers = [ maintainers.Zimmi48 ];
  };
}
