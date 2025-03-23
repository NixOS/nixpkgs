{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  wheel,
  anyio,
  numpy,
  pillow,
  pytest-forked,
  pytest-xdist,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "svgelements";
  version = "1.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meerk40t";
    repo = "svgelements";
    tag = version;
    hash = "sha256-nx2sGXeeh8S17TfRDFifQbdSxc4YGsDNnrPSSbxv7S4=";
  };

  patches = [
    (fetchpatch {
      name = "fix-assert-tests";
      url = "https://github.com/meerk40t/svgelements/commit/23da98941a94cf1afed39c10750222ccfee73c9f.patch";
      hash = "sha256-/53w4eWlaSNEQxuoAxPrN2HciZ3Az2A2SKcIAlNgKAs=";
    })
  ];

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "svgelements" ];

  nativeCheckInputs = [
    anyio
    numpy
    pillow
    pytest-forked
    pytest-xdist
    pytestCheckHook
    scipy
  ];

  meta = {
    description = "SVG Parsing for Elements, Paths, and other SVG Objects";
    homepage = "https://github.com/meerk40t/svgelements";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
