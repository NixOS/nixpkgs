{ lib
, buildPythonPackage
, fetchPypi

# build dependencies
, setuptools

# dependencies
, cbor2
, pyyaml
, regex
}:

buildPythonPackage rec {
  pname = "zcbor";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0mGp7Hnq8ZNEUx/9eQ6UD9/cOuLl6S5Aif1qNh1+jYA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cbor2
    pyyaml
    regex
  ];

  pythonImportsCheck = [ "zcbor" ];

  meta = with lib; {
    description = "A low footprint CBOR library in the C language (C++ compatible), tailored for use in microcontrollers";
    homepage = "https://pypi.org/project/zcbor/";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
  };
}
