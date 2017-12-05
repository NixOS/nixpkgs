{ stdenv
, buildPythonPackage
, fetchgit
, testfixtures
, cornice
, mozsvc
, pybrowserid
, tokenlib
, pymysql
, umemcache
, hawkauthlib
, alembic
, pymysqlsa
, paste
, boto
}:

buildPythonPackage rec {
  name = "tokenserver-${version}";
  version = "1.2.27";

  src = fetchgit {
    url = https://github.com/mozilla-services/tokenserver.git;
    rev = "refs/tags/${version}";
    sha256 = "0il3bgjld495g9gxvvrm56kpan5swaizzg216qz3zxmb6w9ly3fm";
  };

  doCheck = false;
  buildInputs = [ testfixtures ];
  propagatedBuildInputs = [ cornice mozsvc pybrowserid tokenlib
    pymysql umemcache hawkauthlib alembic pymysqlsa paste boto ];

  meta = {
    platforms = stdenv.lib.platforms.all;
  };
}
