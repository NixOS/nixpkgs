{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cython
, h5py
, matplotlib
, numpy
, phonopy
, pymatgen
, scipy
, seekpath
, spglib
, castepxbin
, pytestCheckHook
, colormath
}:

buildPythonPackage rec {
  pname = "sumo";
  version = "2.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SMTG-UCL";
    repo = "sumo";
    rev = "refs/tags/v${version}";
    hash = "sha256-nQ5US7maFcOJCqFYeokGiBFp3jhiOPSfCBeclLdHdkk=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    castepxbin
    colormath
    h5py
    matplotlib
    numpy
    phonopy
    pymatgen
    scipy
    seekpath
    spglib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sumo"
  ];

  meta = with lib; {
    description = "Toolkit for plotting and analysis of ab initio solid-state calculation data";
    homepage = "https://github.com/SMTG-UCL/sumo";
    changelog = "https://github.com/SMTG-Bham/sumo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
