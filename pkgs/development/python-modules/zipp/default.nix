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
  version = "3.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3607921face881ba3e026887d8150cca609d517579abe052ac81fc5aeffdbd76";
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
