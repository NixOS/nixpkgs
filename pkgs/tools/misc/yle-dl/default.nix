{ lib, fetchFromGitHub, rtmpdump, php, pythonPackages, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  pname = "yle-dl";
  version = "20190614";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "1995528c4h7gr1zxs3f2ja1vaw16gbvbig4ra81x78270s5025l9";
  };

  propagatedBuildInputs = with pythonPackages; [
    attrs
    ConfigArgParse
    ffmpeg
    future
    lxml
    mini-amf
    pyamf
    pycrypto
    pycryptodomex
    requests
  ];

  pythonPath = [ rtmpdump php ];

  doCheck = false; # tests require network access
  checkInputs = with pythonPackages; [ pytest pytestrunner ];

  meta = with lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = https://aajanki.github.io/yle-dl/;
    license = licenses.gpl3;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
