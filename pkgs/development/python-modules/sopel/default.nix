{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, praw
, xmltodict
, pytz
, pyenchant
, pygeoip
, python
, isPyPy
, isPy27
}:

buildPythonPackage rec {
  pname = "sopel";
  version = "6.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d8c1dc7e9cad73afc40d849484bc0f626aad6557951b1a0cff437af442ccb99";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ praw xmltodict pytz pyenchant pygeoip ];

  disabled = isPyPy || isPy27;

  checkPhase = ''
    ${python.interpreter} test/*.py                                         #*/
  '';

  meta = with stdenv.lib; {
    description = "Simple and extensible IRC bot";
    homepage = "http://sopel.chat";
    license = licenses.efl20;
    maintainers = with maintainers; [ mog ];
  };

}
