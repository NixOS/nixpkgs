{
  lib,
  buildPythonPackage,
  cdcs,
  datamodeldict,
  fetchFromGitHub,
  ipython,
  lxml,
  numpy,
  pandas,
  pillow,
  pymongo,
  pytestCheckHook,
  tqdm,
  uv-build,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "yabadaba";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "usnistgov";
    repo = "yabadaba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nXGQT/c+Sio3VQTqHY3SOiqJRQCQxZ/o0RCQGptcQig=";
  };

  build-system = [ uv-build ];

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
    changelog = "https://github.com/usnistgov/yabadaba/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
