{ lib
, async-timeout
, bleak
, bleak-retry-connector
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pycryptodome
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yalexs-ble";
  version = "1.12.5";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wofdqwgMbwxUgUVwBT44qbD4m0q0CtmGH7AxRNMBMbE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
    bleak
    bleak-retry-connector
    pycryptodome
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=yalexs_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "yalexs_ble"
  ];

  meta = with lib; {
    description = "Library for Yale BLE devices";
    homepage = "https://github.com/bdraco/yalexs-ble";
    changelog = "https://github.com/bdraco/yalexs-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
