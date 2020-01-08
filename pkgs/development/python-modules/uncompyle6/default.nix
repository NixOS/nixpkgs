{ stdenv
, buildPythonPackage
, fetchPypi
, spark_parser
, xdis
, nose
, pytest
, hypothesis
, six
}:

buildPythonPackage rec {
  pname = "uncompyle6";
  version = "3.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aac071daef4b6cf95143ef08cd35d762a2bf2ea8249119a9371a91149c9996e7";
  };

  checkInputs = [ nose pytest hypothesis six ];
  propagatedBuildInputs = [ spark_parser xdis ];

  # six import errors (yet it is supplied...)
  checkPhase = ''
    runHook preCheck
    pytest ./pytest --ignore=pytest/test_function_call.py
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "Python cross-version byte-code deparser";
    homepage = https://github.com/rocky/python-uncompyle6/;
    license = licenses.gpl3;
  };

}
