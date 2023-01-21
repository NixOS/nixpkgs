{ lib
, buildPythonPackage
, fetchFromGitLab
, pytestCheckHook
, pytest-cov
}:

buildPythonPackage rec {
  pname = "xdgenvpy";
  version = "2.3.5";

  src = fetchFromGitLab {
    owner = "deliberist";
    repo = "xdgenvpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-SZcvLVrHw9SsJ71ULzO3pWmhX4dnV8eG7eiUut4Gp1o=";
  };

  checkInputs = [ pytestCheckHook pytest-cov ];

  meta = with lib; {
    changelog = "https://gitlab.com/deliberist/xdgenvpy/-/blob/v${version}/CHANGELOG.md";
    description = "An XDG Base Directory Specification utility for accessing XDG environment variables.";
    homepage = "https://gitlab.com/deliberist/xdgenvpy";
    license = licenses.mit;
    maintainers = with maintainers; [ felschr ];
  };
}
