{
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "termgraph";
  version = "0.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkaz";
    repo = "termgraph";
    tag = "v${version}";
    hash = "sha256-DptokK79yAfQDuhN2d/HfcaRq//0pF81VkhMfz05Hb0=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "termgraph" ];

  meta = {
    description = "Python command-line tool which draws basic graphs in the terminal";
    mainProgram = "termgraph";
    homepage = "https://github.com/mkaz/termgraph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
