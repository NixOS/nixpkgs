{ stdenv
, lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "openttd-nml";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    rev = version;
    hash = "sha256-AmJrPyzPMe2F8geJhhRpO8aj467n1wqldC9iuzElFnw=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pillow
    ply
  ];

  meta = with lib; {
    homepage = "http://openttdcoop.org/";
    description = "Compiler for OpenTTD NML files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
