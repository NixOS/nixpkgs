{ lib
, python3
, fetchPypi
, fetchFromGitHub
, ffmpeg
}:

let
  python = python3;
in python.pkgs.buildPythonApplication rec {
  pname = "spotdl";
  version = "4.2.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "refs/tags/v${version}";
    hash = "sha256-xKas3WO3uigY1iFfxIN3+d+5U31vM7cLv08oMef8trc=";
  };

  nativeBuildInputs = with python.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = with python.pkgs; [
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
    typing-extensions
    soundcloud-v2
    bandcamp-api
    setuptools # for pkg_resources
  ] ++ python-slugify.optional-dependencies.unidecode;

  nativeCheckInputs = with python.pkgs; [
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
    "test_album_from_url"
    "test_convert"
    "test_download_ffmpeg"
    "test_download_song"
    "test_preload_song"
    "test_ytm_get_results"
    "test_ytm_search"
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
