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
  version = "7.1.6";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ebd3b2aa9230835f8a68ea7f5a10324ddf35d70d89a9c92c8cba81c558565efb";
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
