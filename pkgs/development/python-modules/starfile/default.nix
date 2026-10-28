{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  numpy,
  pandas,
  pyarrow,

  # tests
  typing-extensions,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "starfile";
  version = "0.5.13";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "teamtomo";
    repo = "starfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-klGGDvfRIBAwUoPvEG5qYukzWO94otUmBoMIkjf307I=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    typing-extensions
    pytestCheckHook
  ];

  dependencies = [
    numpy
    pandas
    pyarrow
  ];

  disabledTestPaths = [
    # These tests assume string columns use the NumPy object dtype.
    # Pandas 3 now uses StringDtype instead.
    "tests/test_parsing.py::test_quote_loop"
    "tests/test_parsing.py::test_parse_as_string"

    # recent Pandas may return a read-only array from .values, which breaks the test
    "tests/test_parsing.py::test_parse_na"
  ];

  pythonImportsCheck = [ "starfile" ];

  meta = {
    changelog = "https://github.com/teamtomo/starfile/releases/tag/v${finalAttrs.version}";
    description = "STAR file I/O in Python";
    homepage = "https://teamtomo.org/starfile";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rdk31 ];
  };
})
