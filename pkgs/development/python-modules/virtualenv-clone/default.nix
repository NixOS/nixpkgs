{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, virtualenv
}:

buildPythonPackage rec {
  pname = "virtualenv-clone";
  version = "0.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b3be5cab59e455f08c9eda573d23006b7d6fb41fae974ddaa2b275c93cc4405";
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
