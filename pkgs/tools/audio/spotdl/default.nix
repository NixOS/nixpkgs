{ lib
, python3
, fetchFromGitHub
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "spotdl";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "v${version}";
    sha256 = "sha256-ftSnlruSv+RtvjTpZPYg9Z2EK4th8NbDhVlG2eIc87s=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    spotipy
    pytube
    rich
    rapidfuzz
    mutagen
    ytmusicapi
    tqdm
    beautifulsoup4
    requests
    unidecode
    youtube-dl
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
