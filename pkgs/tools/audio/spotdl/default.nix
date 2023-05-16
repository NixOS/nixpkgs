{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, ffmpeg
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      ytmusicapi = super.ytmusicapi.overridePythonAttrs (old: rec {
        version = "0.25.1";
<<<<<<< HEAD
        src = fetchPypi {
=======
        src = self.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          inherit (old) pname;
          inherit version;
          hash = "sha256-uc/fgDetSYaCRzff0SzfbRhs3TaKrfE2h6roWkkj8yQ=";
        };
      });
    };
  };
in python.pkgs.buildPythonApplication rec {
  pname = "spotdl";
<<<<<<< HEAD
  version = "4.2.0";
=======
  version = "4.1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-miIDasbOKmfYESiEIlMxEUfPkLLBz4s1rX2eMz3MrzA=";
=======
    hash = "sha256-iE5d9enSbONqVxKW7H7N+1TmBp6nVGtiQvxJxV7R/1o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    soundcloud-v2
    bandcamp-api
    setuptools # for pkg_resources
  ] ++ python-slugify.optional-dependencies.unidecode;
=======
    setuptools # for pkg_resources
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    "test_album_from_string"
    "test_album_from_url"
    "test_album_length"
<<<<<<< HEAD
    "test_artist_from_string"
    "test_artist_from_url"
=======
    "test_artist_from_url"
    "test_artist_from_string"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_convert"
    "test_download_ffmpeg"
    "test_download_song"
    "test_playlist_from_string"
    "test_playlist_from_url"
    "test_playlist_length"
    "test_preload_song"
    "test_song_from_search_term"
    "test_song_from_url"
<<<<<<< HEAD
    "test_yt_search"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
