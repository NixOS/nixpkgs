{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "openttd-nml";
  version = "0.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    tag = version;
    hash = "sha256-LZhkyYTtolB9/1ZvwYa+TJJRBIifyuqlMawK7vhPV0k=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pillow
  ];

  meta = with lib; {
    homepage = "http://openttdcoop.org/";
    description = "Compiler for OpenTTD NML files";
    mainProgram = "nmlc";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
