{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, h5py
, matplotlib
, numpy
, phonopy
, pymatgen
, pytest
, scipy
, seekpath
, spglib
}:

buildPythonPackage rec {
  pname = "sumo";
  version = "2.2.1";

  # No tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "SMTG-UCL";
    repo = "sumo";
    rev = "v${version}";
    sha256 = "0r88f5w33h9b0mv7shlqc4przwvas5ycgndvl91wqjnm3b2s3ix0";
  };

  propagatedBuildInputs = [ numpy scipy spglib pymatgen h5py matplotlib seekpath phonopy ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest .
  '';

  # tests have type annotations, can only run on 3.5+
  doCheck = (!isPy27);

  meta = with lib; {
    description = "Toolkit for plotting and analysis of ab initio solid-state calculation data";
    homepage = "https://github.com/SMTG-UCL/sumo";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
