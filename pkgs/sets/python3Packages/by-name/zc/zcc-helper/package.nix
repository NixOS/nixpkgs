{
  buildPythonPackage,
  fetchFromBitbucket,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "zcc-helper";
  version = "3.8.1";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "mark_hannon";
    repo = "zcc";
    tag = "release_${finalAttrs.version}";
    hash = "sha256-2CuzM8QjT0oMpxyd8XFx67Q0Ms0VbcnZSpgaCQr0Tn4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "zcc" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://bitbucket.org/mark_hannon/zcc/src/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "ZIMI ZCC helper module";
    homepage = "https://bitbucket.org/mark_hannon/zcc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
