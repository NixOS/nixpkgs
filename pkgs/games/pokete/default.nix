{ lib
, python3
, fetchFromGitHub
, testers
, pokete
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pokete";
  version = "0.7.3";

  format = "other";

  src = fetchFromGitHub {
    owner = "lxgr-linux";
    repo = "pokete";
    rev = version;
    sha256 = "sha256-sP6fI3F/dQHei1ZJU6gChKxft9fGpTct4EyU3OdBtr4=";
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
      command = "pokete --help";
    };
  };

  meta = with lib; {
    description = "A terminal based Pokemon like game";
    homepage = "https://lxgr-linux.github.io/pokete";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
  };
}
