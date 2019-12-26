{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.4.3";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b6b1afe7731d7d9cbb0398b4a811ebb5e6be5c174f72c68abf81f919a435de9";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ifduyue/python-xxhash;
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
