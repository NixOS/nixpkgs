{ lib
, python3
, fetchFromGitHub
, ffmpeg
}:

let
  python = python3;
in python.pkgs.buildPythonApplication rec {
  pname = "spotdl";
  version = "4.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "refs/tags/v${version}";
    hash = "sha256-vxMhFs2mLbVQndlC2UpeDP+M4pwU9Y4cZHbZ8y3vWbI=";
  };

  build-system = with python.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  dependencies = with python.pkgs; [
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
    soundcloud-v2
    bandcamp-api
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
    "tests/providers/lyrics"
    "tests/types"
    "tests/utils/test_github.py"
    "tests/utils/test_m3u.py"
    "tests/utils/test_metadata.py"
    "tests/utils/test_search.py"
  ];

  disabledTests = [
    # require networking
    "test_convert"
    "test_download_ffmpeg"
    "test_download_song"
    "test_preload_song"
    "test_yt_get_results"
    "test_yt_search"
    "test_ytm_search"
    "test_ytm_get_results"
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ ffmpeg ])
  ];

  meta = with lib; {
    description = "Download your Spotify playlists and songs along with album art and metadata";
    mainProgram = "spotdl";
    homepage = "https://github.com/spotDL/spotify-downloader";
    changelog = "https://github.com/spotDL/spotify-downloader/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
