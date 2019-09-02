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
  version = "6.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa9a52da9cf33c1d5f6b9b8513d31a339d8cbef9a288487b251538949a4faae1";
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
