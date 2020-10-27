{ stdenv, fetchFromGitHub, rtmpdump, php, wget, python3Packages, ffmpeg_3 }:

python3Packages.buildPythonApplication rec {
  pname = "yle-dl";
  version = "20201022";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "0p56pb3wxdzqgs4fsh4hn06xs0mgzgznqqr0bn2vkkkibnkr1asp";
  };

  propagatedBuildInputs = with python3Packages; [
    attrs ConfigArgParse ffmpeg_3 future lxml requests
  ];
  pythonPath = [ rtmpdump php wget ];

  doCheck = false; # tests require network access
  checkInputs = with python3Packages; [ ffmpeg_3 pytest pytestrunner ];

  meta = with stdenv.lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = "https://aajanki.github.io/yle-dl/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
