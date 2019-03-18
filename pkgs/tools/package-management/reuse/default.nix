{ lib, python3Packages, fetchFromGitLab }:

with python3Packages;

buildPythonApplication rec {
  pname = "reuse";
  version = "0.3.4";

  src = fetchFromGitLab {
    owner = "reuse";
    repo = "reuse";
    rev = "v${version}";
    sha256 = "07acv02wignrsfhym2i3dhlcs501yj426lnff2cjampl6m5cgsk3";
  };

  propagatedBuildInputs = [ chardet debian pygit2 ];

  checkInputs = [ pytest jinja2 ];

  # Some path based tests are currently broken under nix
  checkPhase = ''
    pytest tests -k "not test_lint_none and not test_lint_ignore_debian and not test_lint_twice_path"
  '';

  meta = with lib; {
    description = "A tool for compliance with the REUSE Initiative recommendations";
    license = with licenses; [ cc-by-sa-40 cc0 gpl3 ];
    maintainers = [ maintainers.FlorianFranzen ];
  };
}
