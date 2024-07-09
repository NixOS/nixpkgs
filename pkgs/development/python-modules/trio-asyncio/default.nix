{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  greenlet,
  trio,
  outcome,
  sniffio,
  exceptiongroup,
  pytest-trio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "trio-asyncio";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-trio";
    repo = "trio-asyncio";
    rev = "refs/tags/v${version}";
    hash = "sha256-634fcYAn5J1WW71J/USAMkJaZI8JmKoQneQEhz2gYFc=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    greenlet
    trio
    outcome
    sniffio
  ] ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

  pytestFlagsArray = [
    # RuntimeWarning: Can't run the Python asyncio tests because they're not installed
    "-W"
    "ignore::RuntimeWarning"
  ];

  nativeCheckInputs = [
    pytest-trio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "trio_asyncio" ];

  meta = with lib; {
    changelog = "https://github.com/python-trio/trio-asyncio/blob/v${version}/docs/source/history.rst";
    description = "Re-implementation of the asyncio mainloop on top of Trio";
    homepage = "https://github.com/python-trio/trio-asyncio";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ dotlambda ];
  };
}
