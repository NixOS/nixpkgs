{ lib, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  pname = "simpleeval";
  name = "${pname}-${version}";
  version = "0.9.5";
  src = fetchurl {
    url = "mirror://pypi/s/simpleeval/${name}.tar.gz";
    sha256 = "0sda13bqg9l4j17iczmfanxbzsg6fm9aw8i3crzsjfxx51rwj1i3";
  };
  meta = {
    homepage = "https://github.com/danthedeckie/simpleeval";
    description = "A simple, safe single expression evaluator library";
    maintainers = with lib.maintainers; [ johbo ];
    license = lib.licenses.mit;
  };
}
