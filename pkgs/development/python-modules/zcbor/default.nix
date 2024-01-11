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
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-47HwITfFcHNze3tt4vJxHB4BQ7oyl17DM8IV0WomM5Q=";
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
    changelog = "https://github.com/NordicSemiconductor/zcbor/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
  };
}
