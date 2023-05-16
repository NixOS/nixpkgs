{ lib
, fetchFromGitHub
<<<<<<< HEAD
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "catcli";
  version = "0.9.6";
  format = "setuptools";
=======
, buildPythonApplication
, docopt, anytree
}:

buildPythonApplication rec {

  pname = "catcli";
  version = "0.8.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-+/kd7oPT6msojPj25bzG9HwVqPj47gIUg9LngbDc3y8=";
  };

  postPatch = "patchShebangs . ";

  propagatedBuildInputs = with python3.pkgs; [
    anytree
    docopt
    fusepy
    pyfzf
    types-docopt
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "The command line catalog tool for your offline data";
    homepage = "https://github.com/deadc0de6/catcli";
    changelog = "https://github.com/deadc0de6/catcli/releases/tag/v${version}";
=======
    sha256 = "sha256-hVunxgc/aUapQYe6k3hKdkC+2Jw0x1HjI/kl/fJdWUo=";
  };

  propagatedBuildInputs = [ docopt anytree ];

  postPatch = "patchShebangs . ";

  meta = with lib; {
    description = "The command line catalog tool for your offline data";
    homepage = "https://github.com/deadc0de6/catcli";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ petersjt014 ];
    platforms = platforms.all;
  };
}
