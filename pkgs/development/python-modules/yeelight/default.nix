{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  flit-core,
  ifaddr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "yeelight";
  version = "0.7.17";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TrajX5a67MJhtixjnnCJ4aw5NleNHg0gwAORz0NaXiU=";
  };

  build-system = [ flit-core ];

  dependencies = [ ifaddr ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "yeelight/tests.py" ];

  pythonImportsCheck = [ "yeelight" ];

  meta = {
    description = "Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
    changelog = "https://gitlab.com/stavros/python-yeelight/-/blob/v${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
})
