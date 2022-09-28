{ lib
, fetchFromGitHub
, buildPythonApplication
, pexpect
, pyyaml
, openssh
, nixosTests
, pythonOlder
}:

buildPythonApplication rec{
  pname = "xxh";
  version = "0.8.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xZVQamTEQpwxKZxOOhQyaDP4fX2dAI1CTNL94tHuGIw=";
  };

  propagatedBuildInputs = [
    pexpect
    pyyaml
    openssh
  ];

  passthru.tests = {
    inherit (nixosTests) xxh;
  };

  meta = with lib; {
    description = "Bring your favorite shell wherever you go through SSH";
    homepage = "https://github.com/xxh/xxh";
    license = licenses.bsd2;
    maintainers = with maintainers; [ pasqui23 ];
  };
}
