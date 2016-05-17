{pythonPackages, fetchgit}:

pythonPackages.buildPythonApplication {

  name = "nix-cmd";
  version = "2016-01-10";

  src = fetchgit {
    url = https://github.com/FRidh/nix-cmd;
    rev = "c8be0cd8b30fd8edcbb01f3712701c6cd9352b15";
    sha256 = "131rvqqqnnx1c8xy5v322wby43zy70bwiac0knhs3jhj5qdn1wgh";
  };

  propagatedBuildInputs = with pythonPackages; [ click ];

  meta = {
    description = "The nix command provides a user-friendly way to use the Nix package manager";
  };
}
