{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  spglib,
  numpy,
  scipy,
  h5py,
  pymatgen,
  phonopy,
  matplotlib,
  seekpath,
  castepxbin,
  colormath,
  importlib-resources,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sumo";
  version = "2.3.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SMTG-UCL";
    repo = "sumo";
    tag = "v${version}";
    hash = "sha256-A6lwTQsX8J+7+9jkkZjBS0MLcJHneBVpy7RsJA22Bic=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    spglib
    numpy
    scipy
    h5py
    pymatgen
    phonopy
    matplotlib
    seekpath
    castepxbin
    colormath
    importlib-resources
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sumo" ];

  meta = {
    description = "Toolkit for plotting and analysis of ab initio solid-state calculation data";
    homepage = "https://github.com/SMTG-UCL/sumo";
    changelog = "https://github.com/SMTG-Bham/sumo/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
