{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "icdiff-${version}";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    rev = "release-${version}";
    sha256 = "1micpm7kq9swfscmp4mg37fnzgzpsg7704yi33c5sd6cmgbdabxm";
  };

  meta = with stdenv.lib; {
    homepage = https://www.jefftk.com/icdiff;
    description = "Side-by-side highlighted command line diffs";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.psfl;
  };
}
