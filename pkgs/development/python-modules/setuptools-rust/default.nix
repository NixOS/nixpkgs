{ callPackage
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, semantic-version
, setuptools
, setuptools-scm
, typing-extensions
, toml
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "1.1.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0adb9b503c0ffc4e8fe80b7c617898cefa78049983aaaea7f747e153a3e65d1";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ semantic-version setuptools toml typing-extensions ];

  doCheck = false;
  pythonImportsCheck = [ "setuptools_rust" ];

  passthru.tests.pyo3 = callPackage ./pyo3-test { };

  meta = with lib; {
    description = "Setuptools plugin for Rust support";
    homepage = "https://github.com/PyO3/setuptools-rust";
    changelog = "https://github.com/PyO3/setuptools-rust/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
