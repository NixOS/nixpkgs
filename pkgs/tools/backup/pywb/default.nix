{ lib, python3Packages, fetchFromGitHub }:

with lib;

let
  disabledTests = [
    # `AssertionError` due to trailing comma in tuple representation
    "test_another_remote_not_found"
    "test_file_not_found"
    "test_mem_agg_index_1"
    "test_mem_agg_index_2"
    "test_mem_agg_index_5"
    "test_mem_agg_index_5_inverse_preset"
    "test_mem_agg_not_found"
    "test_agg_select_local"
    "test_agg_select_local_postreq"

    # `RuntimeError('generator raised StopIteration')`
    "test_zipnum"

    # Failures in sandbox due to lack of network access
    "test_replay"
    "test_record_skip_http_only_cookies_header"
    "test_loaders"
    "test_remote_loader"
    "test_remote_closest_loader"
    "test_remote_closest_wb_memnto_loader"
    "test_all_not_found"
    "test_agg_select_mem_1"
    "test_agg_select_mem_2"
    "test_agg_select_mem_unrewrite_headers"
    "test_agg_select_live"
    "test_force_https_root_replay_1"
    "test_live_fallback"
    "test_live_live_1"
    "test_proxy_record_keep_percent"
    "test_live_no_redir"
    "test_root_replay_ts"
    "test_root_replay_no_ts"
    "test_root_replay_redir"

    # `AssertionError: assert 3 == 4` due to another test being skipped
    "test_cdx_all_coll"

    # `AppError: Bad response: 404 Not Found` when using Python 2 on Linux
    # or Python 3 on macOS, may fail in other cases
    "test_timemap_all_coll"
  ];

  # Compose the final string expression, including the "-k" and the single quotes.
  testExpression = optionalString (disabledTests != [])
    "-k 'not ${concatStringsSep " and not " disabledTests}'";

in

python3Packages.buildPythonApplication rec {
  name = "pywb-${version}";
  version = "2.1.0";

  # Fetch from GitHub because the PyPi tarball is missing requirements.txt
  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "pywb";
    # 2.1.0 was not tagged but pywb-2.1.0.tar.gz in PyPi was based on this commit
    rev = "1b151b74bfee5bd465ccc70cc04a8d2b2e090db4";
    sha256 = "0ahsk8fhrz0gdiq4i6b3m4jvhxbdsaz1mkdgvy26vb3r4ph24dfa";
  };

  propagatedBuildInputs = with python3Packages; [
    brotlipy chardet gevent jinja2 portalocker py3amf pytest pyyaml redis
    requests six surt warcio webassets webencodings werkzeug wsgiprox
  ];

  checkInputs = with python3Packages; [
    fakeredis httpbin mock pytest ujson urllib3 webtest
  ];
  checkPhase = ''
    # Based on https://github.com/webrecorder/pywb/blob/master/setup.py
    py.test -v --doctest-module ./pywb/ tests/ ${testExpression}
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Web archiving toolkit for creating or replaying web archives";
    homepage = https://github.com/webrecorder/pywb;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ivan ];
    platforms = platforms.all;
  };
}
