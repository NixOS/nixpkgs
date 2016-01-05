{ stdenv, fetchFromGitHub, rtmpdump, php, pythonPackages }:

stdenv.mkDerivation rec {
  name = "yle-dl-${version}";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "1irpcp9iw2cw85sj1kzndmrw8350p9q7cfghjx2xkh2czk9k7whq";
  };

  patchPhase = ''
    substituteInPlace yle-dl --replace '/usr/local/share/' "$out/share/"

    # HACK: work around https://github.com/NixOS/nixpkgs/issues/9593
    substituteInPlace yle-dl --replace '/usr/bin/env python2' '/usr/bin/env python'
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
