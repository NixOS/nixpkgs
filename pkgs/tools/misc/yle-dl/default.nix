{ stdenv, fetchFromGitHub, rtmpdump, php, pythonPackages, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  name = "yle-dl-${version}";
  version = "2.30";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "08qqsg0rmp4xfzmla81f0a4vblqfw3rh90wvxm91vbm6937b4i7i";
  };

  propagatedBuildInputs = with pythonPackages; [ lxml pyamf pycrypto requests future ffmpeg ];
  pythonPath = [ rtmpdump php ];

  doCheck = false; # tests require network access
  checkInputs = with pythonPackages; [ pytest pytestrunner ];

  meta = with stdenv.lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = https://aajanki.github.io/yle-dl/;
    license = licenses.gpl3;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
