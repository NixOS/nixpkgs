{ stdenv, fetchFromGitHub, rtmpdump, php, pythonPackages }:

stdenv.mkDerivation rec {
  name = "yle-dl-${version}";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "1fa2a25j3wwk3m6q1alilklwhqf337ch8rj6bwricc5zqb58qivc";
  };

  patchPhase = ''
    substituteInPlace yle-dl --replace '/usr/local/share/' "$out/share/"
  '';

  buildInputs = [ pythonPackages.wrapPython ];
  pythonPath = [ rtmpdump php ] ++ (with pythonPackages; [ pycrypto ]);

  installPhase = ''
    make install prefix=$out
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = https://aajanki.github.io/yle-dl/;
    license = licenses.gpl3;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
