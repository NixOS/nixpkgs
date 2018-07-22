{ buildPythonPackage
, fetchgit
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
  version = "1.6.11";
  disabled = !isPy27;

  src = fetchgit {
    url = https://github.com/mozilla-services/server-syncstorage.git;
    rev = "refs/tags/${version}";
    sha256 = "197gj2jfs2c6nzs20j37kqxwi91wabavxnfm4rqmrjwhgqjwhnm0";
  };

  checkInputs = [ testfixtures unittest2 webtest ];
  propagatedBuildInputs = [
    pyramid sqlalchemy simplejson mozsvc cornice pyramid_hawkauth pymysql
    pymysqlsa umemcache WSGIProxy requests pybrowserid
  ];

  meta = {
    broken = true; # 2018-11-04
  };
}
