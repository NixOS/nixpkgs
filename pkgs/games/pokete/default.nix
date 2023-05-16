{ lib
, python3
, fetchFromGitHub
, testers
, pokete
<<<<<<< HEAD
, faketty
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pokete";
<<<<<<< HEAD
  version = "0.9.1";
=======
  version = "0.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "other";

  src = fetchFromGitHub {
    owner = "lxgr-linux";
    repo = "pokete";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    sha256 = "sha256-T18908Einsgful8hYMVHl0cL4sIYFvhpy0MbLIcVhxs=";
=======
    sha256 = "sha256-55BqUSZJPDz5g1FTdkuWa9wcsrLwh6YagD5bQ9ZpQv4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonPath = with python3.pkgs; [
    scrap-engine
    pynput
  ];

  buildPhase = ''
    ${python3.interpreter} -O -m compileall .
  '';

  installPhase = ''
    mkdir -p $out/share/pokete
    cp -r assets pokete_classes pokete_data mods *.py $out/share/pokete/
    mkdir -p $out/bin
    ln -s $out/share/pokete/pokete.py $out/bin/pokete
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/share/pokete "$pythonPath"
  '';

  passthru.tests = {
    pokete-version = testers.testVersion {
      package = pokete;
<<<<<<< HEAD
      command = "${faketty}/bin/faketty pokete --help";
      version = "v${version}";
=======
      command = "pokete --help";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  meta = with lib; {
    description = "A terminal based Pokemon like game";
    homepage = "https://lxgr-linux.github.io/pokete";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
  };
}
