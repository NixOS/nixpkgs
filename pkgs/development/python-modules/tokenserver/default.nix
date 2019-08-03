{ lib, buildPythonPackage, fetchFromGitHub
, alembic, boto, cornice, hawkauthlib, mozsvc, paste, pybrowserid, pyfxa
, pymysql, pymysqlsa, sqlalchemy, testfixtures, tokenlib, umemcache
, mock, nose, unittest2, webtest
}:

buildPythonPackage rec {
  pname = "tokenserver";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = version;
    sha256 = "04z0r8xzrmhvh04y8ggdz9gs8qa8lv3qr7kasf6lm63fixsfgrlp";
  };

  propagatedBuildInputs = [
    alembic boto cornice hawkauthlib mozsvc paste pybrowserid pyfxa
    pymysql pymysqlsa sqlalchemy testfixtures tokenlib umemcache
  ];

  checkInputs = [
    mock nose unittest2 webtest
  ];

  # Requires virtualenv, MySQL, ...
  doCheck = false;

  meta = with lib; {
    description = "The Mozilla Token Server";
    homepage = https://github.com/mozilla-services/tokenserver;
    license = licenses.mpl20;
    maintainers = with maintainers; [ nadrieril ];
  };
}
