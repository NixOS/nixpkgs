{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, virtualenv
}:

buildPythonPackage rec {
  pname = "virtualenv-clone";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "180x35mjqfnci7h87gxxkmcvc1vyw8iyd456638hmvgkfyyaii86";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ virtualenv ];

  # needs tox to run the tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/edwardgeorge/virtualenv-clone;
    description = "Script to clone virtualenvs";
    license = licenses.mit;
  };

}
