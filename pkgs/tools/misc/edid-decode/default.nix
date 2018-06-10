{ stdenv, fetchgit }:
let
  version = "2017-09-18";
in stdenv.mkDerivation rec {
  name = "edid-decode-unstable-${version}";

  src = fetchgit {
    url = "git://anongit.freedesktop.org/xorg/app/edid-decode";
    rev = "f56f329ed23a25d002352dedba1e8f092a47286f";
    sha256 = "1qzaq342dsdid0d99y7kj60p6bzgp2zjsmspyckddc68mmz4cs9n";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp edid-decode $out/bin
  '';

  meta = {
    description = "EDID decoder and conformance tester";
    homepage = https://cgit.freedesktop.org/xorg/app/edid-decode/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.chiiruno ];
    platforms = stdenv.lib.platforms.all;
  };
}

