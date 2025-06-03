{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cdcs,
  datamodeldict,
  ipython,
  lxml,
  numpy,
  pandas,
  pillow,
  pymongo,
  tqdm,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "yabadaba";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "yabadaba";
    tag = "v${version}";
    hash = "sha256-DpkJvi4w0aoD7RC2IFORy8uZ12TuLdcJxfLaSGyATac=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cdcs
    datamodeldict
    ipython
    lxml
    numpy
    pandas
    pillow
    pymongo
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "yabadaba" ];

  meta = {
    description = "Abstraction layer allowing for common interactions with databases and records";
    homepage = "https://github.com/usnistgov/yabadaba";
    changelog = "https://github.com/usnistgov/yabadaba/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
