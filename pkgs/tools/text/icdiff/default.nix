{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "icdiff";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    rev = "release-${version}";
    sha256 = "080v8h09pv8qwplin4kwfm0kmqjwdqjfxbpcdrv16sv4hwfwl5qd";
  };

  meta = with stdenv.lib; {
    homepage = "https://www.jefftk.com/icdiff";
    description = "Side-by-side highlighted command line diffs";
    maintainers = with maintainers; [ aneeshusa ];
    license = licenses.psfl;
  };
}
