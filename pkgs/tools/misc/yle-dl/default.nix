{ lib, fetchFromGitHub, rtmpdump, php, wget, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  pname = "yle-dl";
  version = "20210212";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "sha256-0JnigYmslQ/7KsQAFg3AaWPAU/tD1lS7lF6OCcv/ze4=";
  };

  propagatedBuildInputs = with python3Packages; [
    attrs ConfigArgParse ffmpeg future lxml requests
  ];
  pythonPath = [ rtmpdump php wget ];

  doCheck = false; # tests require network access
  checkInputs = with python3Packages; [ ffmpeg pytest pytestrunner ];

  meta = with lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = "https://aajanki.github.io/yle-dl/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
