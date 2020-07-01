{ stdenv, buildPythonPackage, fetchPypi, isPyPy
, dnspython
, geoip2
, ipython
, praw
, pyenchant
, pygeoip
, pytest
, python
, pytz
, xmltodict
}:

buildPythonPackage rec {
  pname = "sopel";
  version = "7.0.4";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8fc7186ff34c5f86ebbf2bff734503e92ce29aaf5a242eaf93875983617c6d0";
  };

  propagatedBuildInputs = [
    dnspython
    geoip2
    ipython
    praw
    pyenchant
    pygeoip
    pytz
    xmltodict
  ];

  # remove once https://github.com/sopel-irc/sopel/pull/1653 lands
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "praw<6.0.0" "praw<7.0.0"
  '';

  checkInputs = [ pytest ];

  checkPhase = ''
    HOME=$PWD # otherwise tries to create tmpdirs at root
    pytest .
  '';

  meta = with stdenv.lib; {
    description = "Simple and extensible IRC bot";
    homepage = "http://sopel.chat";
    license = licenses.efl20;
    maintainers = with maintainers; [ mog ];
  };
}
