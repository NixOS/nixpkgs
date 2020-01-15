{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
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
  version = "1.0.9";

  # No tests in Pypi tarball
  src = fetchFromGitHub {
    owner = "SMTG-UCL";
    repo = "sumo";
    rev = "v${version}";
    sha256 = "1zw86qp9ycw2k0anw6pzvwgd3zds0z2cwy0s663zhiv9mnb5hx1n";
  };

  propagatedBuildInputs = [ numpy scipy spglib pymatgen h5py matplotlib seekpath phonopy ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest .
  '';

  # tests have type annotations, can only run on 3.5+
  doCheck = (!isPy27);

  meta = with stdenv.lib; {
    description = "Toolkit for plotting and analysis of ab initio solid-state calculation data";
    homepage = "https://github.com/SMTG-UCL/sumo";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
