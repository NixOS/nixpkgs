{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, webtest
, pyramid
, sqlalchemy
, simplejson
, mozsvc
, cornice
, pyramid_hawkauth
, pymysql
, pymysqlsa
, umemcache
, requests
, pybrowserid
}:

buildPythonPackage rec {
  pname = "serversyncstorage";
  version = "1.6.14";
  disabled = !isPy27;

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = "server-syncstorage";
    rev = version;
    sha256 = "08xclxj38rav8yay9cijiavv35jbyf6a9jzr24vgcna8pjjnbbmh";
  };

  propagatedBuildInputs = [
    pyramid sqlalchemy simplejson mozsvc cornice pyramid_hawkauth pymysql
    pymysqlsa umemcache requests pybrowserid
    webtest
  ];

  postPatch = ''
    # conflict between WSGIProxy & WSGIProxy2 required by webtest
    # (which is required by pyramid_hawkauth)
    sed -i "s/WSGIProxy.*//" requirements.txt
    sed -i "s/'wsgiproxy',//" setup.py

    # since we disabled tests (which would need WSGIProxy)
    # lets get rid of the rest of the test dependencies as well:
    sed -i "s/unittest2.*//; s/webtest.*//; s/testfixtures.*//" requirements.txt
    sed -i "s/'unittest2',//; s/'webtest',//; s/, 'testfixtures'//" setup.py
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "The SyncServer server software, as used by Firefox Sync";
    homepage = "https://github.com/mozilla-services/server-syncstorage";
    platforms = platforms.unix;
    license = licenses.mpl20;
  };
}
