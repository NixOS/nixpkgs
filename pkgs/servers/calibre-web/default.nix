{ lib
, fetchFromGitHub
, nixosTests
, python3
, python3Packages
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calibre-web";
  version = "0.6.18";

  src = fetchFromGitHub {
    owner = "janeczku";
    repo = "calibre-web";
    rev = version;
    sha256 = "sha256-KjmpFetNhNM5tL34e/Pn1i3hc86JZglubSMsHZWu198=";
  };

  propagatedBuildInputs = with python3Packages; [
    advocate
    backports_abc
    flask-babel
    flask_login
    flask_principal
    flask_wtf
    iso-639
    lxml
    pypdf3
    requests
    sqlalchemy
    tornado
    unidecode
    Wand
    werkzeug
  ];

  patches = [
    # default-logger.patch switches default logger to /dev/stdout. Otherwise calibre-web tries to open a file relative
    # to its location, which can't be done as the store is read-only. Log file location can later be configured using UI
    # if needed.
    ./default-logger.patch
    # DB migrations adds an env var __RUN_MIGRATIONS_ANDEXIT that, when set, instructs calibre-web to run DB migrations
    # and exit. This is gonna be used to configure calibre-web declaratively, as most of its configuration parameters
    # are stored in the DB.
    ./db-migrations.patch
  ];

  # calibre-web doesn't follow setuptools directory structure. The following is taken from the script
  # that calibre-web's maintainer is using to package it:
  # https://github.com/OzzieIsaacs/calibre-web-test/blob/master/build/make_release.py
  postPatch = ''
    mkdir -p src/calibreweb
    mv cps.py src/calibreweb/__init__.py
    mv cps src/calibreweb

    substituteInPlace setup.cfg \
      --replace "cps = calibreweb:main" "calibre-web = calibreweb:main" \
      --replace "Flask>=1.0.2,<2.1.0" "Flask>=1.0.2" \
      --replace "Flask-Login>=0.3.2,<0.5.1" "Flask-Login>=0.3.2" \
      --replace "flask-wtf>=0.14.2,<1.1.0" "flask-wtf>=0.14.2" \
      --replace "lxml>=3.8.0,<4.9.0" "lxml>=3.8.0" \
      --replace "PyPDF3>=1.0.0,<1.0.7" "PyPDF3>=1.0.0" \
      --replace "requests>=2.11.1,<2.28.0" "requests" \
      --replace "unidecode>=0.04.19,<1.4.0" "unidecode>=0.04.19" \
      --replace "werkzeug<2.1.0" ""
  '';

  # Upstream repo doesn't provide any tests.
  doCheck = false;

  passthru.tests.calibre-web = nixosTests.calibre-web;

  meta = with lib; {
    description = "Web app for browsing, reading and downloading eBooks stored in a Calibre database";
    homepage = "https://github.com/janeczku/calibre-web";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pborzenkov ];
    platforms = platforms.all;
  };
}
