{ lib
, fetchFromGitHub
, nixosTests
, python3
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "calibre-web";
  version = "0.6.19";

  src = fetchFromGitHub {
    owner = "janeczku";
    repo = "calibre-web";
    rev = version;
    hash = "sha256-mNYLQ+3u6xRaoZ5oH6HdylFfgz1fq1ZB86AWk9vULWQ=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    APScheduler
    advocate
    chardet
    flask-babel
    flask-login
    flask_principal
    flask-wtf
    iso-639
    lxml
    pypdf3
    requests
    sqlalchemy
    tornado
    unidecode
    wand
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
    # Handle version 3.0 of flask-babel
    (fetchpatch {
      url = "https://github.com/janeczku/calibre-web/commit/94a6931d48d347ae6c07e2b5f0301e8cf97cf53d.patch";
      excludes = [ "requirements.txt" ];
      hash = "sha256-0DQ+LbIOOwjBXQh+b1w8dYQ3s+xZ6nFoH5GvgJdBAFI=";
    })
  ];

  # calibre-web doesn't follow setuptools directory structure. The following is taken from the script
  # that calibre-web's maintainer is using to package it:
  # https://github.com/OzzieIsaacs/calibre-web-test/blob/master/build/make_release.py
  postPatch = ''
    mkdir -p src/calibreweb
    mv cps.py src/calibreweb/__init__.py
    mv cps src/calibreweb

    sed -i "/backports_abc/d" setup.cfg

    substituteInPlace setup.cfg \
      --replace "cps = calibreweb:main" "calibre-web = calibreweb:main" \
      --replace "chardet>=3.0.0,<4.1.0" "chardet>=3.0.0,<6" \
      --replace "Flask>=1.0.2,<2.1.0" "Flask>=1.0.2" \
      --replace "Flask-Babel>=0.11.1,<2.1.0" "Flask-Babel>=0.11.1" \
      --replace "Flask-Login>=0.3.2,<0.6.2" "Flask-Login>=0.3.2" \
      --replace "flask-wtf>=0.14.2,<1.1.0" "flask-wtf>=0.14.2" \
      --replace "lxml>=3.8.0,<4.9.0" "lxml>=3.8.0" \
      --replace "tornado>=4.1,<6.2" "tornado>=4.1,<7" \
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
