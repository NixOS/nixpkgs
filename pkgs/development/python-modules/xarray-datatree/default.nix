{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  check-manifest,
  setuptools,
  setuptools-scm,
  packaging,
  pytestCheckHook,
  xarray,
  zarr,
}:

buildPythonPackage rec {
  pname = "datatree";
  version = "0.0.14";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "xarray-contrib";
    repo = "datatree";
    rev = "refs/tags/v${version}";
    hash = "sha256-C6+WcHc2+sftJ5Yyh/9TTIHhAEwhAqSsSkaDwtq7J90=";
  };

  build-system = [
    check-manifest
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
    zarr
  ];

  pythonImportsCheck = [ "datatree" ];

  disabledTests = [
    # output formatting issue, likely due to underlying library version difference:
    "test_diff_node_data"
  ];

  meta = with lib; {
    description = "Tree-like hierarchical data structure for xarray";
    homepage = "https://xarray-datatree.readthedocs.io";
    changelog = "https://github.com/xarray-contrib/datatree/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
