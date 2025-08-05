{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flatbencode,
  pytest-cov-stub,
  pytest-httpserver,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  setuptools,
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
  ];

  pythonImportsCheck = [ "torf" ];

  meta = with lib; {
    description = "Create, parse and edit torrent files and magnet links";
    homepage = "https://github.com/rndusr/torf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ambroisie ];
  };
}
