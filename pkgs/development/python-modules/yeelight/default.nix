{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitLab,
  flit-core,
  ifaddr,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "yeelight";
  version = "0.7.16";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
    rev = "refs/tags/v${version}";
    hash = "sha256-WLEXTDVcSpGCmfEI31cQXGf9+4EIUCkcaeaj25f4ERU=";
  };

  build-system = [ flit-core ];

  dependencies = [ ifaddr ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "yeelight/tests.py" ];

  pythonImportsCheck = [ "yeelight" ];

  meta = with lib; {
    description = "Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
    changelog = "https://gitlab.com/stavros/python-yeelight/-/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
