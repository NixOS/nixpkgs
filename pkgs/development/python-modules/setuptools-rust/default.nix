{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, semantic-version
, setuptools
, setuptools-scm
, toml
}:

buildPythonPackage rec {
  pname = "setuptools-rust";
  version = "0.11.6";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5b5954909cbc5d66b914ee6763f81fa2610916041c7266105a469f504a7c4ca";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ semantic-version setuptools toml ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "setuptools_rust" ];

  meta = with lib; {
    description = "Setuptools plugin for Rust support";
    homepage = "https://github.com/PyO3/setuptools-rust";
    changelog = "https://github.com/PyO3/setuptools-rust/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
