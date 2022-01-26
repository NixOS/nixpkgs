{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, readthedocs-sphinx-ext
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sphinx-paramlinks";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UbPsymbeXAY+lwGes1TuwXplf0JKADV6BO6YHICtW+k=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  doCheck = false;
  checkInputs = [
    readthedocs-sphinx-ext
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Allows param links in Sphinx function/method descriptions to be linkable";
    homepage = "https://github.com/sqlalchemyorg/sphinx-paramlinks";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
