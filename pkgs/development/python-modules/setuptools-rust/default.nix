{ callPackage
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, semantic-version
, setuptools
, setuptools-scm
, tomli
, typing-extensions
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "1.8.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lLHdXVMIsxONW5M8OitV5taSfRoiYy5Qn86p3dD35IY=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    semantic-version
    setuptools
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [
    "setuptools_rust"
  ];

  doCheck = false;

  passthru.tests.pyo3 = callPackage ./pyo3-test { };

  meta = with lib; {
    description = "Setuptools plugin for Rust support";
    homepage = "https://github.com/PyO3/setuptools-rust";
    changelog = "https://github.com/PyO3/setuptools-rust/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
