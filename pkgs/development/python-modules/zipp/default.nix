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
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c599e4d75c98f6798c509911d08a22e6c021d074469042177c8c86fb92eefd96";
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
