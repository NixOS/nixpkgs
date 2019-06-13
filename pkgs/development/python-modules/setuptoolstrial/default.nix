{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, virtualenv
, pytestrunner
, pytest-virtualenv
, twisted
, pathlib2
}:

buildPythonPackage rec {
  pname = "setuptools_trial";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14220f8f761c48ba1e2526f087195077cf54fad7098b382ce220422f0ff59b12";
  };

  buildInputs = [ pytest virtualenv pytestrunner pytest-virtualenv ];
  propagatedBuildInputs = [ twisted pathlib2 ];

  postPatch = ''
    sed -i '12,$d' tests/test_main.py
  '';

  # Couldn't get tests working
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Setuptools plugin that makes unit tests execute with trial instead of pyunit.";
    homepage = "https://github.com/rutsky/setuptools-trial";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ryansydnor nand0p ];
  };

}
