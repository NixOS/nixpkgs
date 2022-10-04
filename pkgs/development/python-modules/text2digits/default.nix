{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "text2digits";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oB2NyNVxediIulid9A4Ccw878t2JKrIsN1OOR5lyi7I=";
  };

  doCheck = false;

  meta = with lib; {
    description = ''Converts text such as "twenty three" to number/digit "23" in any sentence'';
    homepage = "https://github.com/ShailChoksi/text2digits";
    license = licenses.mit;
  };
}
