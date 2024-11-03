{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "changedetection-io";
  version = "0.47.06";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    rev = "refs/tags/${version}";
    hash = "sha256-kRoHCnXYWG09lrIiBA14OzhtbTqghXck5JXXNAMMtyc=";
  };

  pythonRelaxDeps = true;

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
    flask-cors
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
    loguru
    lxml
    paho-mqtt
    pillow
    playwright
    pyee
    pyppeteer
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
    mainProgram = "changedetection.io";
  };
}
