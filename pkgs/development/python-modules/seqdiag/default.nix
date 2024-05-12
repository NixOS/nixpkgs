{ lib
, blockdiag
, buildPythonPackage
, fetchFromGitHub
, pynose
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "seqdiag";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = "seqdiag";
    rev = "refs/tags/${version}";
    hash = "sha256-Dh9JMx50Nexi0q39rYr9MpkKmQRAfT7lzsNOXoTuphg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    blockdiag
  ];

  nativeCheckInputs = [
    pynose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/seqdiag/tests/"
  ];

  pythonImportsCheck = [
    "seqdiag"
  ];

  meta = with lib; {
    description = "Generate sequence-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    changelog = "https://github.com/blockdiag/seqdiag/blob/${version}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ bjornfor ];
    mainProgram = "seqdiag";
    platforms = platforms.unix;
  };
}
