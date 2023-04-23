{ lib
, fetchFromGitHub
, fetchurl
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "changedetection-io";
  version = "0.40.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    rev = version;
    sha256 = "sha256-RYxhkCSL17rU3C4rOArYptmYpdK/CDPw9xfXkKja2xs=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "cryptography~=3.4" "cryptography" \
      --replace "dnspython<2.3.0" "dnspython" \
      --replace "pytest ~=6.2" "" \
      --replace "pytest-flask ~=1.2" "" \
      --replace "selenium~=4.1.0" "selenium" \
      --replace "werkzeug~=2.0.0" "werkzeug"
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
    homepage = "https://github.com/dgtlmoon/changedetection.io";
    description = "Simplest self-hosted free open source website change detection tracking, monitoring and notification service";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
