{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, virtualenv
}:

buildPythonPackage rec {
  pname = "virtualenv-clone";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7087ba4eb48acfd5209a3fd03e15d072f28742619127c98333057e32748d91c4";
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
