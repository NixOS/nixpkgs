{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "simple-term-menu";
  version = "1.6.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vpxdvY3xKkBLFM2Oldb8AtWMYOJVX2Xd3kF3fEh/s7k=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "simple_term_menu" ];

  # no unit tests in the upstream
  doCheck = false;

  meta = with lib; {
    description = "A Python package which creates simple interactive menus on the command line";
    mainProgram = "simple-term-menu";
    homepage = "https://github.com/IngoMeyer441/simple-term-menu";
    license = licenses.mit;
    changelog = "https://github.com/IngoMeyer441/simple-term-menu/releases/tag/v${version}";
    maintainers = with maintainers; [ smrehman ];
  };
}
