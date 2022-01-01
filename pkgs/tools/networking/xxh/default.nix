{ lib, fetchFromGitHub, buildPythonApplication, pexpect, pyyaml, openssh }:

buildPythonApplication rec{
  pname = "xxh";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-TzC8GTDmnYN56Rp5DyZxh+yGrkgWr6Xt86a/jyB3j5k=";
  };

  propagatedBuildInputs = [ pexpect pyyaml openssh ];

  meta = with lib; {
    description = "Bring your favorite shell wherever you go through ssh";
    homepage = "https://github.com/xxh/xxh";
    license = licenses.bsd2;
    maintainers = [ maintainers.pasqui23 ];
  };
}
