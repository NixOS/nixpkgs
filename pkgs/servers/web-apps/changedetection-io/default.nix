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
  version = "0.39.22.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dgtlmoon";
    repo = "changedetection.io";
    rev = version;
    sha256 = "sha256-qK44m64/skmeoBgHToTyOpeWUF2kgks10OHoAoLim+k=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "bs4" "beautifulsoup4" \
      --replace "cryptography~=3.4" "cryptography" \
      --replace "selenium~=4.1.0" "selenium"
  '';

  propagatedBuildInputs = with py.pkgs; [
    apprise
    beautifulsoup4
    brotli
    chardet
    cryptography
    eventlet
    feedgen
    flask
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

  nativeCheckInputs = with py.pkgs; [
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
