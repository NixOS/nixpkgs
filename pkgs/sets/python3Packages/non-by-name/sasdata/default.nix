{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-requirements-txt,
  hatch-sphinx,
  hatch-vcs,
  h5py,
  lxml,
  matplotlib,
  numpy,
  scipy,
  pytestCheckHook,
}:

let
  pname = "sasdata";
  version = "0.12.2";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasdata";
    tag = "v${version}";
    hash = "sha256-InPiX2+ypjgFjxN8CgUtHskL4SSRDb/8crLgexvQw8U=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
    hatch-sphinx
    hatch-vcs
  ];

  dependencies = [
    h5py
    lxml
    matplotlib
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # need network
  disabledTestPaths = [
    "test/sasdataloader/utest_extension_registry.py::ExtensionRegistryTests::test_compare_remote_file_to_local"
    "test/sasdataloader/utest_sesans.py::sesans_reader::test_full_load"
  ];

  pythonImportsCheck = [ "sasdata" ];

  meta = {
    description = "Package for loading and handling SAS data";
    homepage = "https://github.com/SasView/sasdata";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
