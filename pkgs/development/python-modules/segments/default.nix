{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  setuptools,
  regex,
  csvw,
  clldutils,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "segments";
  version = "2.3.0";
  pyproject = true;
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "segments";
    rev = "v${version}";
    sha256 = "sha256-5VgjaWeinXimpoCBhKBvVOmvcCIWrOqYMQegVDGJAKo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    regex
    csvw
    clldutils
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  meta = with lib; {
    changelog = "https://github.com/cldf/segments/blob/${src.rev}/CHANGES.md";
    description = "Unicode Standard tokenization routines and orthography profile segmentation";
    mainProgram = "segments";
    homepage = "https://github.com/cldf/segments";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
