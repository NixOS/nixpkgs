{ stdenv, buildPythonPackage, fetchPypi, pytest, mock, six, twisted }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "txaio";
  version = "2.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "484cd6c4cdd3f6081b87188f3b2b9a36e02fba6816e8256917c4f6571b567571";
  };

  buildInputs = [ pytest mock ];

  propagatedBuildInputs = [ six twisted ];

  patchPhase = ''
    sed -i '152d' test/test_logging.py
  '';

  # test_chained_callback has been removed just post-2.7.1 because the functionality was decided against and the test
  # breaks on python 3.6 https://github.com/crossbario/txaio/pull/104
  checkPhase = ''
    py.test -k "not (test_sdist or test_chained_callback)"
  '';

  meta = with stdenv.lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio.";
    homepage    = "https://github.com/crossbario/txaio";
    license     = licenses.mit;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
