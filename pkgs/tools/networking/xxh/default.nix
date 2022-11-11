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
  version = "0.8.12";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-3/AU2o72X7FE11NSXC6m9fFhmjzEDZ+OpTXg8yvv62A=";
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
