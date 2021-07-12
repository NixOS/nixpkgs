{ lib
, fetchFromGitHub
, python3
, fetchpatch
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ytmdl";
  version = "2021.06.26";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = version;
    sha256 = "1jpd5zhqg2m9vjjjw4mgzb594q1v1pq1yl65py6kw42bq9w5yl5p";
  };

  patches = [
    # Fixes https://github.com/deepjyoti30/ytmdl/issues/188
    # Only needed until the next major release after 2021.06.26
    (fetchpatch {
      url = "https://github.com/deepjyoti30/ytmdl/commit/37ba821d9692249c1fa563505cf60bd11b8e209e.patch";
      includes = [ "bin/ytmdl" ];
      sha256 = "sha256-VqtthpUL0Oub3DK7tSvAnemOzPPTcLvXXeebZIGOgdc=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4"
  '';


  propagatedBuildInputs = with python3.pkgs; [
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

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ ffmpeg ])
  ];

  # This application has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/deepjyoti30/ytmdl";
    description = "YouTube Music Downloader";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
