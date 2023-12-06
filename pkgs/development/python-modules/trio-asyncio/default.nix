{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, trio
, outcome
, sniffio
, exceptiongroup
, pytest-trio
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "trio-asyncio";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "trio_asyncio";
    inherit version;
    hash = "sha256-fKJLIaGxes3mV1LWkziGuiQoTlL0srDe/k6o7YpjSmI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    trio
    outcome
    sniffio
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/python" # tries to import internal API test.test_asyncio
  ];

  pythonImportsCheck = [
    "trio_asyncio"
  ];

  meta = with lib; {
    changelog = "https://github.com/python-trio/trio-asyncio/blob/v${version}/docs/source/history.rst";
    description = "Re-implementation of the asyncio mainloop on top of Trio";
    homepage = "https://github.com/python-trio/trio-asyncio";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
