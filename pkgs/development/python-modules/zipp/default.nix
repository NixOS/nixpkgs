{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-flake8
, more-itertools
, toml
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed5eee1974372595f9e416cc7bbeeb12335201d8081ca8a0743c954d4446e5cb";
  };

  nativeBuildInputs = [ setuptools_scm toml ];

  propagatedBuildInputs = [ more-itertools ];

  checkInputs = [ pytest pytest-flake8 ];

  checkPhase = ''
    pytest
  '';

  # Prevent infinite recursion with pytest
  doCheck = false;

  meta = with lib; {
    description = "Pathlib-compatible object wrapper for zip files";
    homepage = "https://github.com/jaraco/zipp";
    license = licenses.mit;
  };
}
