{ lib
, buildPythonPackage
, dnspython
, fetchPypi
, geoip2
, ipython
, isPyPy
, praw
, pyenchant
, pygeoip
, pytestCheckHook
, pythonOlder
, pytz
, sqlalchemy
, xmltodict
}:

buildPythonPackage rec {
  pname = "sopel";
  version = "7.1.9";
  format = "setuptools";

  disabled = isPyPy || pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IJ+ovLQv6/UU1oepmUQjzaWBG3Rdd3xvui7FjK85Urs=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "praw>=4.0.0,<6.0.0" "praw" \
      --replace "sqlalchemy<1.4" "sqlalchemy" \
      --replace "xmltodict==0.12" "xmltodict>=0.12"
  '';

  preCheck = ''
    export TESTDIR=$(mktemp -d)
    cp -R ./test $TESTDIR
    pushd $TESTDIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "sopel"
  ];

  meta = with lib; {
    description = "Simple and extensible IRC bot";
    homepage = "https://sopel.chat";
    license = licenses.efl20;
    maintainers = with maintainers; [ mog ];
  };
}
