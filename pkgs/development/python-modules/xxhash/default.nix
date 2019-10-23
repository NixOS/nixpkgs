{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.4.2";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82cdc67b41da904aa2921107e9877814079d9b067a99f19852b5d85e8a40555d";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ifduyue/python-xxhash;
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
