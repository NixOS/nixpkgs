{ lib
, fetchFromGitHub
, fetchurl
, python3
}:
let
  py = python3.override {
    packageOverrides = final: prev: {
      flask = prev.flask.overridePythonAttrs (old: rec {
        version = "2.1.3";
        src = old.src.override {
          inherit version;
          sha256 = "sha256-FZcuUBffBXXD1sCQuhaLbbkCWeYgrI1+qBOjlrrVtss=";
        };
      });
      flask-restful = prev.flask-restful.overridePythonAttrs (old: rec {
        disabledTests = old.disabledTests or [ ] ++ [
          # fails because of flask or werkzeug downgrade
          "test_redirect"
        ];
      });
      werkzeug = prev.werkzeug.overridePythonAttrs (old: rec {
        version = "2.0.3";
        src = old.src.override {
          inherit version;
          sha256 = "sha256-uGP4/wV8UiFktgZ8niiwQRYbS+W6TQ2s7qpQoWOCLTw=";
        };
      });
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "changedetection-io";
  version = "0.39.20.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    rev = version;
    sha256 = "sha256-XhCByQbGWAwWe71jsitpYJnQ2xRIdmhc9mY6Smxmp3w=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "bs4" "beautifulsoup4" \
      --replace "cryptography ~= 3.4" "cryptography" \
      --replace "selenium ~= 4.1.0" "selenium"
  '';

  propagatedBuildInputs = with py.pkgs; [
    flask
    flask-wtf
    eventlet
    validators
    timeago
    inscriptis
    feedgen
    flask-login
    flask-restful
    pytz
    brotli
    requests
    urllib3
    chardet
    wtforms
    jsonpath-ng
    jq
    apprise
    paho-mqtt
    cryptography
    beautifulsoup4
    lxml
    selenium
    werkzeug
    playwright
  ] ++ requests.optional-dependencies.socks;

  # tests can currently not be run in one pytest invocation and without docker
  doCheck = false;

  checkInputs = with py.pkgs; [
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
