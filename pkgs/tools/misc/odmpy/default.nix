{ stdenv
, lib
, fetchFromGitHub
, python3Packages
# ffmpeg enables adding chapter metadata and merging multipart files
, enableFfmpeg ? true
, ffmpeg
}:

python3Packages.buildPythonApplication rec {
  pname = "odmpy";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ping";
    repo = pname;
    rev = version;
    hash = "sha256-h0vt4A4c+oV0JBgnBAX6I52Fr+B+rGEjlXTiwKAG+Qo=";
  };

  buildInputs = lib.optional enableFfmpeg ffmpeg;

  makeWrapperArgs = lib.optionalString enableFfmpeg
    ''--prefix PATH : "${lib.makeBinPath [ ffmpeg ] }"'' ;

  propagatedBuildInputs = with python3Packages; [
    requests
    eyeD3
    mutagen
    termcolor
    tqdm
    beautifulsoup4
    lxml
    iso639-lang
  ];

  # pytests try some downloads; will fail in build sandbox
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ping/odmpy";
    description = "A simple command line manager for OverDrive/Libby loans";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gdinh ];
  };
}
