{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "setconf";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "setconf";
    rev = version;
    hash = "sha256-HYZdDtDlGrT3zssDdMW3559hhC+cPy8qkmM8d9zEa1A=";
  };

  build-system = with python3Packages; [ setuptools ];

  pyproject = true;

  meta = {
    homepage = "https://github.com/xyproto/setconf";
    description = "Small utility for changing settings in configuration textfiles";
    changelog = "https://github.com/xyproto/setconf/releases/tag/${version}";
    mainProgram = "setconf";
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
