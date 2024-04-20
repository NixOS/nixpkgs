{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, greenlet
, trio
, outcome
, sniffio
, exceptiongroup
, pytest-trio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "trio-asyncio";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "trio_asyncio";
    inherit version;
    hash = "sha256-msSKQ8vhZxtBIh7HNq4M2qc0yKOErGNiCWLBXXse3WQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    greenlet
    trio
    outcome
    sniffio
  ] ++ lib.optionals (pythonOlder "3.11") [
    exceptiongroup
  ];

  # RuntimeWarning: Can't run the Python asyncio tests because they're not installed. On a Debian/Ubuntu system, you might need to install the libpython3.11-testsuite package.
  doCheck = false;

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
