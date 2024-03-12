{ lib, python3Packages, fetchFromGitHub, gettext, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "ytcc";
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "woefe";
    repo = "ytcc";
    rev = "v${version}";
    hash = "sha256-pC2uoog+nev/Xa6UbXX4vX00VQQLHtZzbVkxrxO/Pg8=";
  };

  nativeBuildInputs = [
    gettext
    installShellFiles
  ] ++ (with python3Packages; [
    setuptools
  ]);

  propagatedBuildInputs = with python3Packages; [
    yt-dlp
    click
    wcwidth
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

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
    installShellCompletion --cmd ytcc \
      --bash scripts/completions/bash/ytcc.completion.sh \
      --fish scripts/completions/fish/ytcc.fish \
      --zsh scripts/completions/zsh/_ytcc
  '';

  meta = {
    description = "Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account";
    homepage = "https://github.com/woefe/ytcc";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ marius851000 marsam ];
  };
}
