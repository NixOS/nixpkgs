{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  flit-core,
  ifaddr,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yeelight";
  version = "0.7.16";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
    tag = "v${version}";
    hash = "sha256-WLEXTDVcSpGCmfEI31cQXGf9+4EIUCkcaeaj25f4ERU=";
  };

  build-system = [ flit-core ];

  dependencies = [ ifaddr ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "yeelight/tests.py" ];

  pythonImportsCheck = [ "yeelight" ];

  meta = {
    description = "Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
    changelog = "https://gitlab.com/stavros/python-yeelight/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
