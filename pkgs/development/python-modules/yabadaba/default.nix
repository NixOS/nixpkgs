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
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "yabadaba";
    tag = "v${version}";
    hash = "sha256-ZVV/2/RyDj707OEWcwFgQjJImgoiv91ZEutT3RBuWus=";
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
