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
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "materialscloud-org";
    repo = "seekpath";
    tag = "v${version}";
    hash = "sha256-0Y3vIh2fv3kjPvYWFkwt4y7QPUe1Evyh/NK4B+BJx+o=";
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
    homepage = "https://github.com/materialscloud-org/seekpath";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
