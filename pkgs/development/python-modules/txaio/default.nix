{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, six, twisted }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "txaio";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lmllmjjsqzl3w4faq2qhlgkaqn1yn1m7d99k822ib7qgz18bsly";
  };

  buildInputs = [ pytest mock ];

  propagatedBuildInputs = [ six twisted ];

  patchPhase = ''
    sed -i '152d' test/test_logging.py
  '';

  checkPhase = ''
    py.test -k "not test_sdist"
  '';

  meta = with stdenv.lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio.";
    homepage    = "https://github.com/crossbario/txaio";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
