{ lib
, python3
, fetchFromGitHub
}:
python3.pkgs.buildPythonApplication rec {
  pname = "yarGen";
  version = "0.23.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "Neo23x0";
    repo = "yarGen";
    rev = version;
    sha256 = "6PJNAeeLAyUlZcIi0g57sO1Ex6atn7JhbK9kDbNrZ6A=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    chmod +x yarGen.py
    mv yarGen.py $out/bin/yargen

    runHook postInstall
  '';

  propagatedBuildInputs = with python3.pkgs; [
    scandir
    pefile
    lxml
  ];

  meta = with lib; {
    description = "A generator for YARA rules";
    homepage = "https://github.com/Neo23x0/yarGen";
    license = licenses.bsd3;
    maintainers = teams.determinatesystems.members;
  };
}
