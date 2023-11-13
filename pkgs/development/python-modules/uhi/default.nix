{ lib
, fetchPypi
, buildPythonPackage
, hatchling
, hatch-vcs
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "uhi";
  version = "0.3.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "800caf3a5f1273b08bcc3bb4b49228fe003942e23423812b0110546aad9a24be";
  };

  buildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Universal Histogram Interface";
    homepage = "https://uhi.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
