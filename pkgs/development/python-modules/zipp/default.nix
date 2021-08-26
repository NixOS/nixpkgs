{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest
, pytest-flake8
, more-itertools
, toml
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5812b1e007e48cff63449a5e9f4e7ebea716b4111f9c4f9a645f91d579bf0c4";
  };

  nativeBuildInputs = [ setuptools-scm toml ];

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
