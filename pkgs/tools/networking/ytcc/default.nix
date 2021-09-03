{ lib, python3Packages, fetchFromGitHub, gettext }:

python3Packages.buildPythonApplication rec {
  pname = "ytcc";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "woefe";
    repo = "ytcc";
    rev = "v${version}";
    sha256 = "1q0w3b7r93416s28qra608n0d7cjh95nwkzgg23z5hp5sq3w3izr";
  };

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = with python3Packages; [
    click
    feedparser
    lxml
    sqlalchemy
    youtube-dl
    wcwidth
  ];

  checkInputs = with python3Packages; [ nose pytestCheckHook ];

  # Disable tests that touch network or shell out to commands
  disabledTests = [
    "get_channels"
    "play_video"
    "download_videos"
    "update_all"
    "add_channel_duplicate"
    "test_subscribe"
    "test_import"
    "test_import_duplicate"
    "test_update"
    "test_download"
  ];

  meta = {
    description = "Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account";
    homepage = "https://github.com/woefe/ytcc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
