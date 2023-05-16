{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jefferson";
<<<<<<< HEAD
  version = "0.4.5";
=======
  version = "0.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PGtrvZ0cQvdiswn2Bk43c3LbIZqJyvNe5rnTPw/ipUM=";
=======
    hash = "sha256-zW38vcDw4Jz5gO9IHrWRlvUznKvUyPbxkYMxn7VSTpA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    cstruct
<<<<<<< HEAD
    lzallright
=======
    python-lzo
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "jefferson"
  ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "JFFS2 filesystem extraction tool";
    homepage = "https://github.com/onekey-sec/jefferson";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ tnias vlaci ];
=======
    maintainers = with maintainers; [ tnias ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
