{ lib
, buildPythonPackage
, fetchPypi
, trio
, outcome
, sniffio
, pytest-trio
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "trio-asyncio";
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "trio_asyncio";
    inherit version;
    sha256 = "sha256-fKJLIaGxes3mV1LWkziGuiQoTlL0srDe/k6o7YpjSmI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  propagatedBuildInputs = [
    trio
    outcome
    sniffio
  ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # https://github.com/python-trio/trio-asyncio/issues/112
    "-W" "ignore::DeprecationWarning"
    # trio.MultiError is deprecated since Trio 0.22.0; use BaseExceptionGroup (on Python 3.11 and later) or exceptiongroup.BaseExceptionGroup (earlier versions) instead (https://github.com/python-trio/trio/issues/2211)
    "-W" "ignore::trio.TrioDeprecationWarning"
  ];

  disabledTestPaths = [
    "tests/python" # tries to import internal API test.test_asyncio
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    "test_run_task"
  ];

  pythonImportsCheck = [
    "trio_asyncio"
  ];

  meta = with lib; {
    description = "Re-implementation of the asyncio mainloop on top of Trio";
    homepage = "https://github.com/python-trio/trio-asyncio";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
