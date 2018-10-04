{ stdenv
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "siphashc";
  version = "1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gq9rb0fy2hiw5bpxzh4i2ha640m9hr8hf941v2mg9aslp0v23xq";
  };

  meta = with stdenv.lib; {
    description = "Python c-module for siphash";
    homepage = https://github.com/WeblateOrg/siphashc;
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
