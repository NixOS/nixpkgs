{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yapsy";
  version = "1.12.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "Yapsy";
    inherit version;
    sha256 = "12rznbnswfw0w7qfbvmmffr9r317gl1rqg36nijwzsklkjgks4fq";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yapsy" ];

  meta = with lib; {
    homepage = "https://yapsy.sourceforge.net/";
    description = "Yet another plugin system";
    license = licenses.bsd0;
  };
}
