{ stdenv
, lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "openttd-nml";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    rev = "refs/tags/${version}";
    hash = "sha256-+TJZ6/JazxzXyKawFE4GVh0De1LTUI95vXQwryJ2NDk=";
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
