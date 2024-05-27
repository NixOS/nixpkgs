{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build dependencies
  setuptools,

  # dependencies
  cbor2,
  pyyaml,
  regex,
}:

buildPythonPackage rec {
  pname = "zcbor";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U3Y/r3tBhzK6bGnMxdqKzS7bLHyAzgpGZ5PVK9pw7Pk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cbor2
    pyyaml
    regex
  ];

  pythonImportsCheck = [ "zcbor" ];

  meta = with lib; {
    description = "A low footprint CBOR library in the C language (C++ compatible), tailored for use in microcontrollers";
    mainProgram = "zcbor";
    homepage = "https://pypi.org/project/zcbor/";
    changelog = "https://github.com/NordicSemiconductor/zcbor/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
  };
}
