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
  version = "0.8.9";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-Uo7xFwE9e5MFWDlNWq15kg+4xf/hF4WGUNTpTK+rgVg=";
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
