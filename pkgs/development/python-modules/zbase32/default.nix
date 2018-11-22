{ stdenv
, buildPythonPackage
, fetchPypi
, setuptoolsDarcs
}:

buildPythonPackage rec {
  pname = "zbase32";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f44b338f750bd37b56e7887591bf2f1965bfa79f163b6afcbccf28da642ec56";
  };

  # Tests require `pyutil' so disable them to avoid circular references.
  doCheck = false;

  propagatedBuildInputs = [ setuptoolsDarcs ];

  meta = with stdenv.lib; {
    description = "zbase32, a base32 encoder/decoder";
    homepage = https://pypi.python.org/pypi/zbase32;
    license = licenses.bsd0;
  };

}
