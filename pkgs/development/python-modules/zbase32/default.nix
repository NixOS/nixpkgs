{ stdenv
, buildPythonPackage
, fetchPypi
, setuptoolsDarcs
, pyutil
}:

buildPythonPackage rec {
  pname = "zbase32";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b25c34ba586cbbad4517af516e723599a6f38fc560f4797855a5f3051e6422f";
  };

  # Tests require `pyutil' so disable them to avoid circular references.
  doCheck = false;

  propagatedBuildInputs = [ setuptoolsDarcs pyutil ];

  meta = with stdenv.lib; {
    description = "zbase32, a base32 encoder/decoder";
    homepage = https://pypi.python.org/pypi/zbase32;
    license = licenses.bsd0;
  };

}
