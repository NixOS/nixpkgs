{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "1.4.1";
  pname = "xxhash";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wgx83lpf8rq95784afj5y9jfcrs1mf6k3pjfyp4a9zigz1zhnkb";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/ifduyue/python-xxhash;
    description = "Python Binding for xxHash https://pypi.org/project/xxhash/";
    license = licenses.bsd2;
    maintainers = [ maintainers.teh ];
  };
}
