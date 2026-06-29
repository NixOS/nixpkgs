{ lib
, python
, buildPythonPackage
, fetchPypi
, pythonOlder
}:
buildPythonPackage rec {
  pname = "magika";
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-490ixzk2Ywsc150PQS1tmlPcmbpeNwmxrFP1a8mY5jU=";
  };

  nativeBuildInputs = with python.pkgs; [
    hatchling
  ];

  propagatedBuildInputs = with python.pkgs; [
    onnxruntime
    numpy
    typing-extensions
    coloredlogs
    click
    python-dotenv
  ];

  nativeCheckInputs = with python.pkgs; [
    pytest-xdist
    pytest
  ];

  pythonImportsCheck = [ "magika" ];

  meta = with lib; {
    description = "Detect file content types with deep learning";
    homepage = "https://github.com/google/magika";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}