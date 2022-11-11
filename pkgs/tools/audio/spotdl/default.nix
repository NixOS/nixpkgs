{ lib
, python3
, fetchFromGitHub
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "spotdl";
  version = "3.9.6";

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "refs/tags/v${version}";
    hash = "sha256-JoeNVMuEslz7A7G4ZvikimZrG75YrH5Mx3Oamtfy4cM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    spotipy
    pytube
    rich
    rapidfuzz
    mutagen
    ytmusicapi
    yt-dlp
    beautifulsoup4
    requests
    unidecode
    setuptools
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-mock
    pytest-vcr
    pyfakefs
    pytest-subprocess
  ];

  # requires networking
  doCheck = false;

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ ffmpeg ])
  ];

  meta = with lib; {
    description = "Download your Spotify playlists and songs along with album art and metadata";
    homepage = "https://github.com/spotDL/spotify-downloader";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
