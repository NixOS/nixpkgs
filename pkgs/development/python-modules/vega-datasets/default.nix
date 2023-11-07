{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pandas
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vega-datasets";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "vega_datasets";
    inherit version;
    hash = "sha256-nb6YNCCOjsMqtElw3zFd6RAoYeTNoT2OFDqreoDZP8A=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [ pandas ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    "--doctest-modules"
  ];

  pythonImportsCheck = [
    "vega_datasets"
  ];

  meta = with lib; let
    tag = removeSuffix ".0" "v${version}";
  in {
    description = "A Python package for offline access to vega datasets";
    homepage = "https://github.com/altair-viz/vega_datasets";
    changelog = "https://github.com/altair-viz/vega_datasets/blob/${tag}/CHANGES.md";
    license = licenses.mit;
  };
}
