{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "whichcraft";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5df20674e0a90028b5633417510f0001b63bc0f345ab3cbb184dd4b221d125ec";
  };

  checkInputs = [ pytest ];

  meta = with lib; {
    homepage = https://github.com/pydanny/whichcraft;
    description = "Cross-platform cross-python shutil.which functionality";
    license = licenses.bsd3;
  };
}
