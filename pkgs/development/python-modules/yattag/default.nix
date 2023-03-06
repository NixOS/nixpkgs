{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lg+lS+EinZb0MXgTPgsZXAAzkf3Ens22tptzdNtr5BY=";
  };

  meta = with lib; {
    description = "Library to generate HTML or XML";
    homepage = "https://www.yattag.org/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
  };
}
