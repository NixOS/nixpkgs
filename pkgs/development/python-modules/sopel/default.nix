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
  version = "6.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40d76188ed51a2c612d2d75bd0a5a36f3cf31e3d7ac072d2798a247c2e7a0927";
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
