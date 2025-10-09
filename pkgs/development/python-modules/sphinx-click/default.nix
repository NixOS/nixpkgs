{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinxHook,
  # Build system
  pbr,
  setuptools,
  # Dependencies
  click,
  docutils,
  sphinx,
  # Checks
  pytestCheckHook,
  defusedxml,
}:

buildPythonPackage rec {
  pname = "sphinx-click";
  version = "6.0.0";
  pyproject = true;

  build-system = [
    pbr
    setuptools
  ];

  nativeBuildInputs = [
    sphinxHook
  ];

  dependencies = [
    click
    docutils
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    defusedxml
  ];

  pythonImportsCheck = [
    "sphinx_click"
  ];

  src = fetchPypi {
    inherit version;
    pname = "sphinx_click";
    hash = "sha256-9dZkMh3AxmIv8Bnx4chOWM4M7P3etRDgBM9gwqOrRls=";
  };

  meta = {
    description = "Sphinx extension that automatically documents click applications";
    homepage = "https://github.com/click-contrib/sphinx-click";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
