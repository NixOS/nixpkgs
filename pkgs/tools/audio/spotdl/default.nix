{ lib
, python3
, fetchFromGitHub
, fetchpatch
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "spotdl";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "spotDL";
    repo = "spotify-downloader";
    rev = "v${version}";
    sha256 = "sha256-Mc0aODyt0rwmBhkvY/gH1ODz4k8LOxyU5xXglSb6sPs=";
  };

  patches = [
    # https://github.com/spotDL/spotify-downloader/pull/1254
    (fetchpatch {
      name = "subprocess-dont-use-shell.patch";
      url = "https://github.com/spotDL/spotify-downloader/commit/fe9848518900577776b463ef0798796201e226ac.patch";
      sha256 = "1kqq3y31dcx1zglywr564hkd2px3qx6sk3rkg7yz8n5hnfjhp6fn";
    })
  ];

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
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-mock
    pytest-vcr
    pyfakefs
    pytest-subprocess
  ];

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
