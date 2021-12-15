{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "log4shell-detector";
  version = "unstable-2021-12-15";
  format = "other";

  src = fetchFromGitHub {
    owner = "Neo23x0";
    repo = pname;
    rev = "66d974af40049c0cab7b0d7f988e5d705031f3af";
    sha256 = "sha256-wKNJWbnDPY3+k7RwEjJws1h4nIqL22Dr2m88CbJZ/rg=";
  };

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  installPhase = ''
    runHook preInstall
    install -vD ${pname}.py $out/bin/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Detector for Log4Shell exploitation attempts";
    homepage = "https://github.com/Neo23x0/log4shell-detector";
    # https://github.com/Neo23x0/log4shell-detector/issues/24
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
  };
}
