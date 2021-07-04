{ stdenv, lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "openttd-nml";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    rev = version;
    sha256 = "0kfnkshff3wrxsj1wpfbbw2mmgww2q80v63p5d2pp1f38x8j33w9";
  };

  propagatedBuildInputs = with python3Packages; [ply pillow];

  meta = with lib; {
    description = "Compiler for OpenTTD NML files";
    homepage    = "http://openttdcoop.org/";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ ToxicFrog ];
  };
}
