{ lib, fetchFromGitHub, fetchPypi, python3, stdenv }:

python3.pkgs.buildPythonApplication rec {
  name = "pywb";
  version = "2.7.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "pywb";
    rev = "v-${version}";
    sha256 = "sha256-M44TwBzXuF33HNLB2OjmBKNDG9kt/qhGEOu589YGvsQ=";
    # TODO: We clone the wombat submodule, but we still need to implement
    # building wombat.
    fetchSubmodules = true;
  };

  patches = [ ./pywb.patch ];

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "jinja2"
    "redis"
    "markupsafe"
    "fakeredis"
    "gevent"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    brotlipy
    chardet
    fakeredis
    gevent
    jinja2
    markupsafe
    portalocker
    py3amf
    pytest
    python-dateutil
    pyyaml
    redis
    requests
    six
    surt
    ua-parser
    warcio
    webassets
    webencodings
    werkzeug
    wsgiprox
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    mock
    webtest
    urllib3
    httpbin
    flask
    ujson
    lxml
    fakeredis
  ];

  doCheck = true;

  disabledTests = [
    # 400 Bad Request.
    "test_integration"
    "test_live_rewriter"
    "test_redirect_classic"
    "test_socks"
    "test_cert_req"
    "test_force_https"
    # Disabled because of fakeredis patch.
    "test_single_redis_entry"
    "test_single_warc_record"
    "test_redis_pending_count"
  ];

  meta = {
    description = "Python web archiving toolkit for creating and replaying web archives";
    homepage = "https://github.com/webrecorder/pywb";
    license = with lib.licenses; [ gpl3Plus agpl3Plus ];
    maintainers = with lib.maintainers; [ anpandey ];
    platforms = lib.platforms.all;
  };
}
