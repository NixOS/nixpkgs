{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-restful
, flask-sqlalchemy
, requests
, jwcrypto
, cryptography
, dnspython
, gunicorn
, pip
, zeep
}:

buildPythonPackage rec {
  pname = "serles-acme";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dvtirol";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dfEItEQqEAnpfbX5AW5a+ZnI7UmCyGCWfm92W+dCWEY=";
  };

  propagatedBuildInputs = [
    flask
    flask-restful
    flask-sqlalchemy
    requests
    jwcrypto
    cryptography
    dnspython
    zeep
  ];

  patches = [
    # Remove bin/serles because it references a global config file
    ./remove-bin.patch
  ];

  nativeCheckInputs = [
    pip
  ];

  meta = with lib; {
    homepage = src.meta.homepage;
    description = "Pluggable ACME: a tiny ACME-CA implementation to enhance existing CA infrastructure";
    platforms = platforms.unix;
    maintainers = with maintainers; [ bouk ];
    license = with licenses; [ gpl3Plus ];
  };
}
