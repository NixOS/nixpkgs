{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  flatbencode,

  # test
  pytest-cov-stub,
  pytest-httpserver,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torf";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rndusr";
    repo = "torf";
    tag = "v${version}";
    hash = "sha256-vJapB4Tbn3tLLUIH9LemU9kTqG7TsByiotkWM52lsno=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    flatbencode
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-httpserver
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests = [
    # Those tests fail DNS resolution in the sandbox
    "test_getting_info__xs_fails__as_fails"
    "test_getting_info__xs_returns_invalid_bytes"
    "test_getting_info__as_returns_invalid_bytes"
    "test_file_in_singlefile_torrent_has_wrong_size"
    "test_file_in_singlefile_torrent_doesnt_exist"
    # Broken assertion
    # AssertionError: assert 1000 < 1000
    "test_callback_raises_exception"
  ];

  pythonImportsCheck = [ "torf" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Create, parse and edit torrent files and magnet links";
    homepage = "https://github.com/rndusr/torf";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
}
