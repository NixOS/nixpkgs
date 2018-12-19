{ stdenv
, buildPythonPackage
, fetchPypi
, testtools
}:

buildPythonPackage rec {
  pname = "testscenarios";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c257cb6b90ea7e6f8fef3158121d430543412c9a87df30b5dde6ec8b9b57a2b6";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "buffer = 1" "" \
      --replace "catch = 1" ""
  '';

  propagatedBuildInputs = [ testtools ];

  meta = with stdenv.lib; {
    description = "A pyunit extension for dependency injection";
    homepage = https://pypi.python.org/pypi/testscenarios;
    license = licenses.asl20;
  };

}
