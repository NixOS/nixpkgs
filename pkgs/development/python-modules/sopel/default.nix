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
  version = "7.1.4";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d778ec2b92866eddf97d0809968bc5f9887cb5a000a518a4b67d8eb999cb775c";
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
    homepage = "http://sopel.chat";
    license = licenses.efl20;
    maintainers = with maintainers; [ mog ];
  };
}
