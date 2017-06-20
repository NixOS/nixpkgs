{ stdenv, fetchFromGitHub, rtmpdump, php, pythonPackages }:

stdenv.mkDerivation rec {
  name = "yle-dl-${version}";
  version = "2.17";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "06szrcm1xlz6i736qkxzhhvrzg63shxzy2bww91bgxfccmkapa14";
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
