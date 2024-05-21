{ lib
, fetchFromGitHub
, nixosTests
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "ssh-audit";
  version = "3.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jtesta";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-g5h0A1BJqzOZaSVUxyi7IsCcrbto4+7+HpiVjFZy50Y=";
  };

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit (nixosTests) ssh-audit;
  };

  meta = with lib; {
    description = "Tool for ssh server auditing";
    mainProgram = "ssh-audit";
    homepage = "https://github.com/jtesta/ssh-audit";
    changelog = "https://github.com/jtesta/ssh-audit/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ tv SuperSandro2000 ];
  };
}
