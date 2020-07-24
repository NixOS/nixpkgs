{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.4.4";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0impn5fbs9h8qjnbvn7j2v25lh20z8gbcx5xi9dhhzcp2z9gjvbx";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/ifduyue/python-xxhash";
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
