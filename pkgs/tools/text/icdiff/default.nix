{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "icdiff-${version}";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    rev = "release-${version}";
    sha256 = "03gcgj3xsqasvgkr8r0q1ljbw2kd2xmfb21qpxhk9lqqm2gl11sv";
  };

  meta = with stdenv.lib; {
    homepage = https://www.jefftk.com/icdiff;
    description = "Side-by-side highlighted command line diffs";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.psfl;
  };
}
