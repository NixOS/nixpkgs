{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-flake8
, more-itertools
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3718b1cbcd963c7d4c5511a8240812904164b7f381b647143a89d3b98f9bcd8e";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ more-itertools ];

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
