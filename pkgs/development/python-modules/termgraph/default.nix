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
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkaz";
    repo = "termgraph";
    tag = "v${version}";
    hash = "sha256-a1Tq0zJKhD1EJN4EDDajsIVbBLP8eVXJvhEY9TsXZ4Q=";
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
