{ lib, python3Packages, fetchFromGitHub, gettext, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "ytcc";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "woefe";
    repo = "ytcc";
    rev = "v${version}";
    sha256 = "sha256-NTG7CtmlJzrhgr/JRSQ1jjSpJEm+PlF67PlEbPNihFE=";
  };

  nativeBuildInputs = [ gettext installShellFiles ];

  propagatedBuildInputs = with python3Packages; [
    yt-dlp
    click
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

  postInstall = ''
    installManPage doc/ytcc.1
  '';

  meta = {
    description = "Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account";
    homepage = "https://github.com/woefe/ytcc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ marius851000 marsam ];
  };
}
