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
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64ad89efee774d1897a58607895d80789c59778ea02185dd846ac38394a8642b";
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
