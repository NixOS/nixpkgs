{ lib, python3, fetchFromGitHub, ncurses }:

python3.pkgs.buildPythonApplication rec {
  pname = "swaglyrics";
  version = "unstable-2021-06-17";

  src = fetchFromGitHub {
    owner = "SwagLyrics";
    repo = "SwagLyrics-For-Spotify";
    rev = "99fe764a9e45cac6cb9fcdf724c7d2f8cb4524fb";
    sha256 = "sha256-O48T1WsUIVnNQb8gmzSkFFHTOiFOKVSAEYhF9zUqZz0=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    unidecode colorama beautifulsoup4 flask requests swspotify
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace 'beautifulsoup4==4.9.3' 'beautifulsoup4>=4.9.3' \
      --replace 'unidecode==1.2.0' 'unidecode>=1.2.0' \
      --replace 'flask==2.0.1' 'flask>=2.0.1'
  '';

  preBuild = "export HOME=$NIX_BUILD_TOP";

  # disable tests which touch network
  disabledTests = [
     "test_database_for_unsupported_song"
     "test_that_lyrics_works_for_unsupported_songs"
     "test_that_get_lyrics_works"
     "test_lyrics_are_shown_in_tab"
     "test_songchanged_can_raise_songplaying"
  ];

  checkInputs = with python3.pkgs;
    [ blinker swspotify pytestCheckHook flask mock flask_testing ]
    ++ [ ncurses ];

  meta = with lib; {
    description = "Lyrics fetcher for currently playing Spotify song";
    homepage = "https://github.com/SwagLyrics/SwagLyrics-For-Spotify";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
