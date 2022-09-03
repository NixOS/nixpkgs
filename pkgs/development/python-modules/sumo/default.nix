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
  version = "2.3.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SMTG-UCL";
    repo = "sumo";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-XEs4lLbVwN00UDnDC0kUNlut9RFXPfcyevBA1f1UqSU=";
  };

  postPatch = ''
    # Loosen castepxbin dependency version pinning
    # https://github.com/SMTG-UCL/sumo/issues/173
    substituteInPlace setup.py \
      --replace "castepxbin==0.1.0" "castepxbin>=0.1.0"
  '';

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

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sumo"
  ];

  meta = with lib; {
    description = "Toolkit for plotting and analysis of ab initio solid-state calculation data";
    homepage = "https://github.com/SMTG-UCL/sumo";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
