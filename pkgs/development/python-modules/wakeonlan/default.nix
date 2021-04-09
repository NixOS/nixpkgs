{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wakeonlan";
  version = "2.0.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "remcohaszing";
    repo = "pywakeonlan";
    rev = version;
    sha256 = "0p9jyiv0adcymbnmbay72g9phlbhsr4kmrwxscbdjq81gcmxsi0y";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Switch to poetry-core, https://github.com/remcohaszing/pywakeonlan/pull/19
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/remcohaszing/pywakeonlan/commit/6aa5050ed94ef718dfcd0b946546b6a738f47ee3.patch";
      sha256 = "1xzj2464ziwm7bp05bzbjwjp9whmgp1py3isr41d92qvnil86vm6";
    })
  ];

  pytestFlagsArray = [ "test_wakeonlan.py" ];

  pythonImportsCheck = [ "wakeonlan" ];

  meta = with lib; {
    description = "A small python module for wake on lan";
    homepage = "https://github.com/remcohaszing/pywakeonlan";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
