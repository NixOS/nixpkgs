{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cbmem";
  version = "4.9";

  src = fetchurl {
    url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
    sha256 = "0xkai65d3z9fivwscbkm7ndcw2p9g794xz8fwdv979w77n5qsdij";
  };

  buildPhase = ''
    make -C util/cbmem
  '';

  installPhase = ''
    install -Dm755 util/cbmem/cbmem $out/bin/cbmem
  '';

  meta = with stdenv.lib; {
    description = "Read coreboot timestamps and console logs";
    homepage = "https://www.coreboot.org";
    license = licenses.gpl2;
    maintainers = [ maintainers.petabyteboy ];
    platforms = platforms.linux;
  };
}

