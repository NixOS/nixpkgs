{ callPackage
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, semantic-version
, setuptools
, setuptools-scm
, typing-extensions
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "1.5.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DgXkVmRdWUKcsQITcK7ec8B2DpNgu/2q77W87VMOudc=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ semantic-version setuptools typing-extensions ];

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
