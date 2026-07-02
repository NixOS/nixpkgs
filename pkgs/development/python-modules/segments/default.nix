{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  setuptools,
  regex,
  csvw,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "segments";
  version = "2.4.0";
  pyproject = true;
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "segments";
    rev = "v${version}";
    sha256 = "sha256-XhJH87Bb9wGNPpPymRjgPYLv2zr4hGAyIAbTMk0uCU0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    regex
    csvw
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
  ];

  meta = {
    changelog = "https://github.com/cldf/segments/blob/${src.rev}/CHANGES.md";
    description = "Unicode Standard tokenization routines and orthography profile segmentation";
    mainProgram = "segments";
    homepage = "https://github.com/cldf/segments";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
