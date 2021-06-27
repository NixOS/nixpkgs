{ lib, fetchFromGitHub, buildPythonApplication, ffmpeg, ffmpeg-python, musicbrainzngs, rich, simber
, pydes, youtube-search, unidecode, pyxdg, downloader-cli, beautifulsoup4, itunespy, mutagen, pysocks
, youtube-dl, ytmusicapi
}:

buildPythonApplication rec {
  pname = "ytmdl";
  version = "2021.06.26";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = version;
    sha256 = "1jpd5zhqg2m9vjjjw4mgzb594q1v1pq1yl65py6kw42bq9w5yl5p";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4"
  '';


  propagatedBuildInputs = [
    ffmpeg
    ffmpeg-python
    musicbrainzngs
    rich
    simber
    pydes
    youtube-search
    unidecode
    pyxdg
    downloader-cli
    beautifulsoup4
    itunespy
    mutagen
    pysocks
    youtube-dl
    ytmusicapi
  ];

  # This application has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/deepjyoti30/ytmdl";
    description = "YouTube Music Downloader";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ j0hax ];
  };
}
