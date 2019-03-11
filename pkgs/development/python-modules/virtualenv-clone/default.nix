{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, virtualenv
}:

buildPythonPackage rec {
  pname = "virtualenv-clone";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "217bd3f0880c9f85672c0bcc9ad9e0354ab7dfa89c2f117e63aa878b4279f5bf";
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
