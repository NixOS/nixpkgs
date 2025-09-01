{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "simple-term-menu";
  version = "1.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "IngoMeyer441";
    repo = "simple-term-menu";
    tag = "v${version}";
    hash = "sha256-nfMqtyUalt/d/wTyRUlu5x4Q349ARY8hDMi8Ui4cTI4=";
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
