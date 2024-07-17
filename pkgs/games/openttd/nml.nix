{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "openttd-nml";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    rev = "refs/tags/${version}";
    hash = "sha256-OobTyPD7FtYMhJL3BDFXaZCOO2iPn8kjEw2OEdqQbr8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pillow
    ply
  ];

  meta = with lib; {
    homepage = "http://openttdcoop.org/";
    description = "Compiler for OpenTTD NML files";
    mainProgram = "nmlc";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
