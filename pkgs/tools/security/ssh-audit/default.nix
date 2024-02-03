{ lib
, fetchFromGitHub
, nixosTests
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jtesta";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-pO6qpY1gqE40bb7q8J/35Dd0XckoFAaIBwWjFsxFO3c=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit (nixosTests) ssh-audit;
  };

  meta = with lib; {
    description = "Tool for ssh server auditing";
    homepage = "https://github.com/jtesta/ssh-audit";
    changelog = "https://github.com/jtesta/ssh-audit/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ tv SuperSandro2000 ];
  };
}
