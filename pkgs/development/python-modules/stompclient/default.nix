{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, mock
, nose
}:

buildPythonPackage rec {
  pname = "stompclient";
  version = "0.3.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "95a4e98dd0bba348714439ea11a25ee8a74acb8953f95a683924b5bf2a527e4e";
  };

  buildInputs = [ mock nose ];

  # XXX: Ran 0 tests in 0.217s

  meta = with stdenv.lib; {
    description = "Lightweight and extensible STOMP messaging client";
    homepage = https://bitbucket.org/hozn/stompclient;
    license = licenses.asl20;
  };

}
