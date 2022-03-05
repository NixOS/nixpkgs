{ stdenv, lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "openttd-nml";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    rev = version;
    sha256 = "0z0n4lqvnqigfjjhmmz7mvis7iivd4a8d287ya2yscfg5hznnqh2";
  };

  propagatedBuildInputs = with python3Packages; [ply pillow];

  meta = with lib; {
    description = "Compiler for OpenTTD NML files";
    homepage    = "http://openttdcoop.org/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
