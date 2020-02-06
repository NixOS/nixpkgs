{ lib, python3Packages, fetchFromGitHub, gettext }:

python3Packages.buildPythonApplication rec {
  pname = "ytcc";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "woefe";
    repo = "ytcc";
    rev = "v${version}";
    sha256 = "0a4gxdan3aivbpkxw9cv1bgl7rfrwdii12d096dx06zlymb27gqs";
  };

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = with python3Packages; [ feedparser lxml sqlalchemy youtube-dl ];

  checkInputs = with python3Packages; [ nose pytest ];

  # Disable tests that touch network or shell out to commands
  checkPhase = ''
    pytest . -k 'not get_channels \
                 and not play_video \
                 and not download_videos \
                 and not update_all \
                 and not add_channel_duplicate'
  '';

  meta = {
    description = "Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account";
    homepage = "https://github.com/woefe/ytcc";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
