{ lib
, python3
, fetchFromGitHub
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "spotdl";
  # The websites spotdl (sometimes indirectly) deals with are a moving target.
  # That means that downloads do occasionally break. Because of that, updates
  # should always be backported to the latest stable release.
  version = "4.1.3";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "refs/tags/v${version}";
    hash = "sha256-XsOecKwSgLWasZw3A4LKSSwEfq93oQM9IrsAIR2M28o=";
  };

  patches = [
    # fix redundant unconditional network access for all tests
    # see spotdl issue #1789 -- should be included in next (or 2nd next?) release
    ./0001-utils-search.py-lazily-initalize-YTMusic-client.patch
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = with python3.pkgs; [
    spotipy
    ytmusicapi
    pytube
    yt-dlp
    mutagen
    rich
    beautifulsoup4
    requests
    rapidfuzz
    python-slugify
    uvicorn
    pydantic
    fastapi
    platformdirs
    pykakasi
    syncedlyrics
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-mock
    pytest-vcr
    pyfakefs
    pytest-subprocess
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # require networking
    "tests/test_init.py"
    "tests/test_matching.py"
    "tests/utils/test_m3u.py"
    "tests/utils/test_metadata.py"
    "tests/utils/test_search.py"
  ];

  disabledTests = [
    # require networking
    "test_album_from_string"
    "test_album_from_url"
    "test_album_length"
    "test_artist_from_url"
    "test_artist_from_string"
    "test_convert"
    "test_download_ffmpeg"
    "test_download_song"
    "test_playlist_from_string"
    "test_playlist_from_url"
    "test_playlist_length"
    "test_preload_song"
    "test_song_from_search_term"
    "test_song_from_url"
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ ffmpeg ])
  ];

  meta = with lib; {
    description = "Download your Spotify playlists and songs along with album art and metadata";
    homepage = "https://github.com/spotDL/spotify-downloader";
    changelog = "https://github.com/spotDL/spotify-downloader/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
