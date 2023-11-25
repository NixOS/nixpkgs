{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "changedetection-io";
  version = "0.45.7.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    rev = version;
    hash = "sha256-axj23LEZgSNpwkVtXQ/2QZVbbV+xTpkf57ajYnqTGFA=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "apprise~=1.6.0" "apprise" \
      --replace "cryptography~=3.4" "cryptography" \
      --replace "dnspython~=2.4" "dnspython" \
      --replace "pytest ~=7.2" "" \
      --replace "pytest-flask ~=1.2" "" \
      --replace "selenium~=4.14.0" "selenium" \
      --replace "werkzeug~=3.0" "werkzeug"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    apprise
    beautifulsoup4
    brotli
    chardet
    cryptography
    dnspython
    eventlet
    feedgen
    flask
    flask-compress
    flask-expects-json
    flask-login
    flask-paginate
    flask-restful
    flask-wtf
    inscriptis
    jinja2
    jinja2-time
    jsonpath-ng
    jq
    lxml
    paho-mqtt
    pillow
    playwright
    pytz
    requests
    selenium
    setuptools
    timeago
    urllib3
    validators
    werkzeug
    wtforms
  ] ++ requests.optional-dependencies.socks;

  # tests can currently not be run in one pytest invocation and without docker
  doCheck = false;

  nativeCheckInputs = with python3.pkgs; [
    pytest-flask
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Self-hosted free open source website change detection tracking, monitoring and notification service";
    homepage = "https://github.com/dgtlmoon/changedetection.io";
    changelog = "https://github.com/dgtlmoon/changedetection.io/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mikaelfangel ];
  };
}
