{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
}:

buildPythonApplication rec {
  pname = "setconf";
  version = "0.7.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "setconf";
    rev = version;
    hash = "sha256-HYZdDtDlGrT3zssDdMW3559hhC+cPy8qkmM8d9zEa1A=";
  };

  meta = {
    homepage = "https://github.com/xyproto/setconf";
    description = "Small utility for changing settings in configuration textfiles";
    changelog = "https://github.com/xyproto/setconf/releases/tag/${version}";
    maintainers = [ lib.maintainers.AndersonTorres ];
    mainProgram = "setconf";
  };
}
