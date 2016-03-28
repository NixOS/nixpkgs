{ stdenv, fetchFromGitHub, buildPythonApplication }:

buildPythonApplication rec {
  name = "icdiff-${version}";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    rev = "release-${version}";
    sha256 = "1k7dlf2i40flsrvkma1k1vii9hsjwdmwryx65q0n0yj4frv7ky6k";
  };

  meta = with stdenv.lib; {
    homepage = https://www.jefftk.com/icdiff;
    description = "Side-by-side highlighted command line diffs";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.psfl;
  };
}
