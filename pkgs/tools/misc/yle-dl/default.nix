{ stdenv, fetchFromGitHub, rtmpdump, php, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "yle-dl-${version}";
  version = "2.20";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "06wzv230hfh3w9gs245kff8666bsfbax3ibr5zxj3h5z4qhhf9if";
  };

  pythonPath = [ rtmpdump php ] ++ (with pythonPackages; [ pycrypto ]);

  meta = with stdenv.lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = https://aajanki.github.io/yle-dl/;
    license = licenses.gpl3;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
