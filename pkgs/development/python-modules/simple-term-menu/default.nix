{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "simple-term-menu";
  version = "1.6.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mBPTb1dJ1i0gClWZseyIRpxxN4MSrcCEwAwAv7s4OJM=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "simple_term_menu" ];

  # no unit tests in the upstream
  doCheck = false;

  meta = with lib; {
    description = "Python package which creates simple interactive menus on the command line";
    mainProgram = "simple-term-menu";
    homepage = "https://github.com/IngoMeyer441/simple-term-menu";
    license = licenses.mit;
    changelog = "https://github.com/IngoMeyer441/simple-term-menu/releases/tag/v${version}";
    maintainers = with maintainers; [ smrehman ];
  };
}
