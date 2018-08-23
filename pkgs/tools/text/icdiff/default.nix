{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "icdiff-${version}";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    rev = "release-${version}";
    sha256 = "10hv09sg7m8gzjf1v785kvim9ps81akzyx7ws6ypylyxc0l2fdcl";
  };

  meta = with stdenv.lib; {
    homepage = https://www.jefftk.com/icdiff;
    description = "Side-by-side highlighted command line diffs";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.psfl;
  };
}
