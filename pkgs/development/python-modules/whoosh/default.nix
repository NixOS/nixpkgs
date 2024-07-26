{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "Whoosh";
  version = "2.7.4";
  src = fetchPypi {
    inherit pname version;
    sha256 = "10qsqdjpbc85fykc1vgcs8xwbgn4l2l52c8d83xf1q59pwyn79bw";
  };

  nativeCheckInputs = [ pytest ];

  # Wrong encoding
  postPatch = ''
    rm tests/test_reading.py
    substituteInPlace setup.cfg --replace "[pytest]" "[tool:pytest]"
  '';
  checkPhase =  ''
    # FIXME: test_minimize_dfa fails on python 3.6
    py.test -k "not test_timelimit and not test_minimize_dfa"
  '';

  meta = with lib; {
    description = "Fast, pure-Python full text indexing, search, and spell
checking library.";
    homepage    = "https://bitbucket.org/mchaput/whoosh";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
