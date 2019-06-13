{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-flake8
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55ca87266c38af6658b84db8cfb7343cdb0bf275f93c7afaea0d8e7a209c7478";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytest-flake8 ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Pathlib-compatible object wrapper for zip files";
    homepage = https://github.com/jaraco/zipp;
    license = licenses.mit;
  };
}
