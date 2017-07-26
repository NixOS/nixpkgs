{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Whoosh";
  version = "2.7.4";
  src = fetchPypi {
    inherit pname version;
    sha256 = "10qsqdjpbc85fykc1vgcs8xwbgn4l2l52c8d83xf1q59pwyn79bw";
  };
  buildInputs = [ pytest ];

  # Wrong encoding
  postPatch = ''
    rm tests/test_reading.py
  '';
  checkPhase =  ''
    # FIXME: test_minimize_dfa fails on python 3.6
    py.test -k "not test_timelimit and not test_minimize_dfa"
  '';

  meta = with stdenv.lib; {
    description = "Fast, pure-Python full text indexing, search, and spell
checking library.";
    homepage    = "http://bitbucket.org/mchaput/whoosh";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ nand0p ];
    platforms   = platforms.all;
  };
}
