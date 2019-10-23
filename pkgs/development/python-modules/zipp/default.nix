{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-flake8
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4970c3758f4e89a7857a973b1e2a5d75bcdc47794442f2e2dd4fe8e0466e809a";
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
