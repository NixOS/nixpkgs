{ lib
, python3
, fetchFromGitHub
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "spotdl";
  version = "4.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "refs/tags/v${version}";
    hash = "sha256-OhZXxGkcO/dlYth9xUnpd/IbyvsbjMzwqQ9lPSvnFSs=";
  };

  build-system = with python3.pkgs; [ poetry-core ];

  pythonRelaxDeps = true;

  dependencies = with python3.pkgs; [
    beautifulsoup4
    fastapi
    mutagen
    platformdirs
    pydantic
    pykakasi
    python-slugify
    pytube
    rapidfuzz
    requests
    rich
    soundcloud-v2
    spotipy
    syncedlyrics
    uvicorn
    yt-dlp
    ytmusicapi
  ] ++ python-slugify.optional-dependencies.unidecode;

  nativeCheckInputs = with python3.pkgs; [
    pyfakefs
    pytest-mock
    pytest-subprocess
    pytest-vcr
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # Tests require networking
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
    # Test require networking
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
    homepage = "https://github.com/spotDL/spotify-downloader";
    changelog = "https://github.com/spotDL/spotify-downloader/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "spotdl";
  };
}
