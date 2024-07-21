{ lib, fetchFromGitHub, python3Packages, bash, git, less }:

python3Packages.buildPythonApplication rec {
  pname = "icdiff";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "jeffkaufman";
    repo = "icdiff";
    rev = "release-${version}";
    sha256 = "080v8h09pv8qwplin4kwfm0kmqjwdqjfxbpcdrv16sv4hwfwl5qd";
  };

  nativeCheckInputs = [
    bash
    git
    less
  ];

  # error: could not lock config file /homeless-shelter/.gitconfig: No such file or directory
  doCheck = false;

  checkPhase = ''
    patchShebangs test.sh
    ./test.sh ${python3Packages.python.interpreter}
  '';

  meta = with lib; {
    homepage = "https://www.jefftk.com/icdiff";
    description = "Side-by-side highlighted command line diffs";
    maintainers = with maintainers; [ ];
    license = licenses.psfl;
  };
}
