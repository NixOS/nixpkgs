{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scipy,
  spglib,
  glibcLocales,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "seekpath";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "giovannipizzi";
    repo = "seekpath";
    rev = "v${version}";
    hash = "sha256-8Nm8SKHda2qt1kncXZxC4T3cpicXpDZhxPzs78JICzE=";
  };

  LC_ALL = "en_US.utf-8";

  build-system = [ setuptools ];

  dependencies = [
    numpy
    spglib
  ];

  optional-dependencies = {
    bz = [ scipy ];
  };

  nativeBuildInputs = [ glibcLocales ];

  pythonImportsCheck = [ "seekpath" ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.bz;

  meta = {
    description = "Module to obtain and visualize band paths in the Brillouin zone of crystal structures";
    homepage = "https://github.com/giovannipizzi/seekpath";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
