{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02iahfkfa927hb4jq2bak36ldihwapzacfiq5lyxg8llwn98a1yi";
  };

  meta = with stdenv.lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = https://github.com/ionelmc/python-tblib;
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
