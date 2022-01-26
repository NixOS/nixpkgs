{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, sphinx_paramlinks
, sphinx_rtd_theme
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "segno";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uOkII7erUkkETSLwIikbsG4RIQR3nWM5uvCZf61lbJo=";
  };

  propagatedBuildInputs = [
    sphinx
    sphinx_paramlinks
    sphinx_rtd_theme
  ];

  doCheck = false;
  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "QR Code and Micro QR Code encoder";
    homepage = "https://github.com/heuer/segno/";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };

}
