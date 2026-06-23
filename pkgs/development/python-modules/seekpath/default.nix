{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  numpy,
  scipy,
  spglib,
  glibcLocales,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "seekpath";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "giovannipizzi";
    repo = "seekpath";
    tag = "v${version}";
    hash = "sha256-yz9IX68AmFP8P8uzZMKa4d/pdzbOm0IcQsZMvC7MuSU=";
  };

  env.LC_ALL = "en_US.utf-8";

  build-system = [ flit-core ];

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
