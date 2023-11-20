{ lib
, python3Packages
, fetchPypi
, yt-dlp
, ffmpeg
}:

python3Packages.buildPythonApplication rec {
  pname = "ytmdl";
  version = "2023.07.27";

  src = fetchPypi {
    inherit pname;
    version = builtins.replaceStrings [ ".0" ] [ "." ] version;
    sha256 = "sha256-sBRzbUR+zqS8Zzg/uU4bjJUr/n1/tb0K6u/FVTEIRsk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4" \
      --replace "/etc/bash_completion.d" "share/bash-completion/completions" \
      --replace "/usr/share/zsh/functions/Completion/Unix" "share/zsh/site-functions"
    sed -i '/python_requires=/d' setup.py
  '';

  propagatedBuildInputs = with python3Packages; [
    ffmpeg-python
    musicbrainzngs
    rich
    simber
    pydes
    youtube-search-python
    unidecode
    pyxdg
    downloader-cli
    beautifulsoup4
    itunespy
    mutagen
    pysocks
    yt-dlp
    ytmusicapi
    spotipy
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
