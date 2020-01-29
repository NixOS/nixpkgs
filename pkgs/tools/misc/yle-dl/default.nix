{ stdenv, fetchFromGitHub, rtmpdump, php, pythonPackages, ffmpeg }:

pythonPackages.buildPythonApplication rec {
  pname = "yle-dl";
  version = "2.31";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "0k93p9csyjm0w33diwl5s22kzs3g78jl3n9k8nxxpqrybfjl912f";
  };

  propagatedBuildInputs = with pythonPackages; [
    lxml pyamf pycrypto requests future ffmpeg setuptools
  ];
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
