{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "openttd-nml";
  version = "0.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "nml";
    tag = version;
    hash = "sha256-swAkUhduIhcfbAvKsPaJNBXcv8T6GDaxk3KKLLa9GQ8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pillow
  ];

  meta = {
    homepage = "http://openttdcoop.org/";
    description = "Compiler for OpenTTD NML files";
    mainProgram = "nmlc";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ToxicFrog ];
  };
}
