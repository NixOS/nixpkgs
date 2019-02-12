{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, testfixtures
, unittest2
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
, WSGIProxy
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

  checkInputs = [ testfixtures unittest2 webtest ];
  propagatedBuildInputs = [
    pyramid sqlalchemy simplejson mozsvc cornice pyramid_hawkauth pymysql
    pymysqlsa umemcache WSGIProxy requests pybrowserid
  ];

  meta = with stdenv.lib; {
    description = "The SyncServer server software, as used by Firefox Sync";
    homepage = https://github.com/mozilla-services/server-syncstorage;
    license = licenses.mpl20;
    maintainers = with maintainers; [ nadrieril ];
  };
}
