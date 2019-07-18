{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-flake8
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca943a7e809cc12257001ccfb99e3563da9af99d52f261725e96dfe0f9275bc3";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytest-flake8 ];

  checkPhase = ''
    pytest
  '';

  # Prevent infinite recursion with pytest
  doCheck = false;

  meta = with lib; {
    description = "Pathlib-compatible object wrapper for zip files";
    homepage = https://github.com/jaraco/zipp;
    license = licenses.mit;
  };
}
