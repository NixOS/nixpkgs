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
}:

buildPythonPackage rec {
  pname = "sumo";
  version = "2.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "SMTG-UCL";
    repo = "sumo";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hY1rQG4s5j/lVvu5e+5e+GamKrYpviqxaWmq1qB6ejU=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    spglib
    numpy
    scipy
    h5py
    pymatgen
    phonopy
    matplotlib
    seekpath
    castepxbin
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # slight disagreement between caastepxbin versions
    "test_castep_phonon_read_bands"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "castepxbin==0.1.0" "castepxbin>=0.1.0"
  '';

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
