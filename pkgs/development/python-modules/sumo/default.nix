{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, scipy, spglib, pymatgen, h5py, matplotlib, seekpath, phonopy }:

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
  
  meta = with stdenv.lib; {
    description = "Toolkit for plotting and analysis of ab initio solid-state calculation data";
    homepage = https://github.com/SMTG-UCL/sumo;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

