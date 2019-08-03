{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ifdtool-${version}";
  version = "4.9";

  src = fetchurl {
    url = "https://coreboot.org/releases/coreboot-${version}.tar.xz";
    sha256 = "0xkai65d3z9fivwscbkm7ndcw2p9g794xz8fwdv979w77n5qsdij";
  };

  buildPhase = ''
    make -C util/ifdtool
    '';

  installPhase = ''
    install -Dm755 util/ifdtool/ifdtool $out/bin/ifdtool
    '';

  meta = with stdenv.lib; {
    description = "Extract and dump Intel Firmware Descriptor information";
    homepage = https://www.coreboot.org;
    license = licenses.gpl2;
    maintainers = [ maintainers.petabyteboy ];
    platforms = platforms.linux;
  };
}

