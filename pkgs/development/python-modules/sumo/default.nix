{ lib, buildPythonPackage, fetchFromGitHub
, pythonOlder
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
  version = "2.2.5";

  disabled = pythonOlder "3.6";

  # No tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "SMTG-UCL";
    repo = "sumo";
    rev = "v${version}";
    sha256 = "1vwqyv215yf51j1278cn7l8mpqmy1grm9j7z3hxjlz4w65cff324";
  };

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

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Toolkit for plotting and analysis of ab initio solid-state calculation data";
    homepage = "https://github.com/SMTG-UCL/sumo";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
