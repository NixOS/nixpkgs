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
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dm/gPFQaeQOrz5tcqqgCt4d4dh188QVjL4r8isXgiWY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cbor2
    pyyaml
    regex
  ];

  pythonImportsCheck = [ "zcbor" ];

  meta = with lib; {
    description = "Low footprint CBOR library in the C language (C++ compatible), tailored for use in microcontrollers";
    mainProgram = "zcbor";
    homepage = "https://pypi.org/project/zcbor/";
    changelog = "https://github.com/NordicSemiconductor/zcbor/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ otavio ];
  };
}
