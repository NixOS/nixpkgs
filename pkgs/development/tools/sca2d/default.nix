{ lib
, python3
, fetchFromGitLab
, fetchFromGitHub
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      lark010 = super.lark.overridePythonAttrs (old: rec {
        version = "0.10.0";

        src = fetchFromGitHub {
          owner = "lark-parser";
          repo = "lark";
          rev = "refs/tags/${version}";
          sha256 = "sha256-ctdPPKPSD4weidyhyj7RCV89baIhmuxucF3/Ojx1Efo=";
        };

        patches = [ ];

        disabledTestPaths = [ "tests/test_nearley/test_nearley.py" ];
      });
    };
    self = python;
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "sca2d";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "bath_open_instrumentation_group";
    repo = "sca2d";
    rev = "v${version}";
    hash = "sha256-P+7g57AH8H7q0hBE2I9w8A+bN5M6MPbc9gA0b889aoQ=";
  };

  propagatedBuildInputs = with python.pkgs; [ lark010 colorama ];

  pythonImportsCheck = [ "sca2d" ];

  meta = with lib; {
    description = "Experimental static code analyser for OpenSCAD";
    mainProgram = "sca2d";
    homepage = "https://gitlab.com/bath_open_instrumentation_group/sca2d";
    changelog = "https://gitlab.com/bath_open_instrumentation_group/sca2d/-/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ traxys ];
  };
}
