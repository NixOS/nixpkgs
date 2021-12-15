{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "log4shell-detector";
  version = "unstable-2021-12-14";
  format = "other";

  src = fetchFromGitHub {
    owner = "Neo23x0";
    repo = pname;
    rev = "7bc368f376b8d95282193eac6ea3970c363577d5";
    sha256 = "sha256-MLKd2moMLwAZXqZ5I/pIYzV0PqVwSpze3gNM0IioI1E=";
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
