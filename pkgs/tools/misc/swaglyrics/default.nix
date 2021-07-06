{ lib, python3, fetchFromGitHub, ncurses }:

python3.pkgs.buildPythonApplication rec {
  pname = "swaglyrics";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "SwagLyrics";
    repo = "SwagLyrics-For-Spotify";
    rev = "v${version}";
    sha256 = "1dwj9fpyhqqpm2z3imp8hfribkzxya891shh77yg77rc2xghp7mh";
  };

  propagatedBuildInputs = with python3.pkgs; [
    unidecode colorama beautifulsoup4 flask requests swspotify
  ];

  preConfigure = ''
    substituteInPlace setup.py \
      --replace 'requests>=2.24.0' 'requests~=2.23' \
      --replace 'beautifulsoup4==4.9.1' 'beautifulsoup4~=4.9' \
      --replace 'colorama==0.4.3' 'colorama~=0.4' \
      --replace 'unidecode==1.1.1' 'unidecode~=1.2'
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
    platforms = platforms.linux;
  };
}
