{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "pymusic-dl";
  version = "3.0.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-A/cBv7TIZX3Vhua3HNwV5sbQmk/DrePm9qykV9X9Rko=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    prettytable
    pycryptodome
    requests
  ];

  checkInputs = [ python3Packages.pytestCheckHook ];

  # These tests require internet access.
  disabledTestPaths = [
    "tests/test_addon_baidu.py"
    "tests/test_addon_kugou.py"
    "tests/test_addon_netease.py"
    "tests/test_addon_qq.py"
    "tests/test_addon_xiami.py"
    "tests/test_song.py"
    "tests/test_source.py"
  ];

  meta = with lib; {
    description = "Search and download music from multiple sources";
    homepage = "https://github.com/0xHJK/music-dl";
    maintainers = with maintainers; [ pmy ];
    license = licenses.mit;
  };
}
