{ lib, buildPythonPackage, fetchPypi, isPyPy
, dnspython
, geoip2
, ipython
, praw
, pyenchant
, pygeoip
, pytestCheckHook
, pytz
, sqlalchemy
, xmltodict
}:

buildPythonPackage rec {
  pname = "sopel";
  version = "7.1.7";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4eb12e9753162e4c19a1bfdd42aea9eb7f5f15e316a6609b925350792fb454fd";
  };

  propagatedBuildInputs = [
    dnspython
    geoip2
    ipython
    praw
    pyenchant
    pygeoip
    pytz
    sqlalchemy
    xmltodict
  ];

  # remove once https://github.com/sopel-irc/sopel/pull/1653 lands
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "praw>=4.0.0,<6.0.0" "praw" \
      --replace "sqlalchemy<1.4" "sqlalchemy"
  '';

  checkInputs = [ pytestCheckHook ];

  preCheck = ''
    export TESTDIR=$(mktemp -d)
    cp -R ./test $TESTDIR
    pushd $TESTDIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [ "sopel" ];

  meta = with lib; {
    description = "Simple and extensible IRC bot";
    homepage = "https://sopel.chat";
    license = licenses.efl20;
    maintainers = with maintainers; [ mog ];
  };
}
