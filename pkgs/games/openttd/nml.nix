{ stdenv
, lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "openttd-nml";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    rev = "refs/tags/${version}";
    hash = "sha256-tmipHRe6qXoSLNbc0OEKxBJZrmTX3DEiuSfQeWRj1sU=";
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
