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
  version = "6.6.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c32aa69ba8a9ae55daf6dbc265d7f56fe6026edef3bb81aeea7912b7b6b9f5b7";
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
