{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "whichcraft";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e0d51c9387cb7e9f28b7edb549e6a03da758f7784f991eb4397d7f7808c57fd";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = https://github.com/pydanny/whichcraft;
    description = "Cross-platform cross-python shutil.which functionality";
    license = licenses.bsd3;
  };
}
