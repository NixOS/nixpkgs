{ stdenv, fetchFromGitHub, rtmpdump, php, pythonPackages }:

stdenv.mkDerivation rec {
  name = "yle-dl-${version}";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "1mvgw8ppv33j04mjsyb5rxg358v3i2zfgazwm7nc3ysc5yl091j5";
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
