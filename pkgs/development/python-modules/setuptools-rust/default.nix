{ callPackage
, lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, semantic-version
, setuptools
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "0.12.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "647009e924f0ae439c7f3e0141a184a69ad247ecb9044c511dabde232d3d570e";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ semantic-version setuptools toml ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "setuptools_rust" ];

  passthru.tests.pyo3 = callPackage ./pyo3-test {};

  meta = with lib; {
    description = "Setuptools plugin for Rust support";
    homepage = "https://github.com/PyO3/setuptools-rust";
    changelog = "https://github.com/PyO3/setuptools-rust/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
