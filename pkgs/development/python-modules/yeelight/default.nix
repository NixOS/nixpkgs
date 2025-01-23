{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitLab,
  fetchpatch2,
  flit-core,
  ifaddr,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "yeelight";
  version = "0.7.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "stavros";
    repo = "python-yeelight";
    rev = "refs/tags/v${version}";
    hash = "sha256-BnMvRs95rsmoBa/5bp0zShgU1BBHtZzyADjbH0y1d/o=";
  };

  patches = [
    (fetchpatch2 {
      name = "remove-future-dependency.patch";
      url = "https://gitlab.com/stavros/python-yeelight/-/commit/654f4f34e0246e65d8db02a107e2ab706de4806d.patch";
      hash = "sha256-olKpYCzIq/E7zup40Kwzwgk5iOtCubLHo9uQDOhaByQ=";
    })
  ];

  build-system = [ flit-core ];

  dependencies = [ ifaddr ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "yeelight/tests.py" ];

  pythonImportsCheck = [ "yeelight" ];

  meta = with lib; {
    description = "Python library for controlling YeeLight RGB bulbs";
    homepage = "https://gitlab.com/stavros/python-yeelight/";
    changelog = "https://gitlab.com/stavros/python-yeelight/-/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
