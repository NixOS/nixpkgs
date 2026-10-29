{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  regex,
  csvw,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage (finalAttrs: {
  pname = "segments";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cldf";
    repo = "segments";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XhJH87Bb9wGNPpPymRjgPYLv2zr4hGAyIAbTMk0uCU0=";
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
    changelog = "https://github.com/cldf/segments/blob/${finalAttrs.src.rev}/CHANGES.md";
    description = "Unicode Standard tokenization routines and orthography profile segmentation";
    mainProgram = "segments";
    homepage = "https://github.com/cldf/segments";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
