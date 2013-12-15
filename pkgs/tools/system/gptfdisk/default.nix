{ fetchurl, stdenv, libuuid, popt, icu, ncurses }:

stdenv.mkDerivation rec {
  name = "gptfdisk-0.8.8";

  src = fetchurl {
    url = "mirror://sourceforge/gptfdisk/${name}.tar.gz";
    sha256 = "16myqa72mp0wyhca8il299h1gd6k6sr7m52qcr97j840wk0fjcac";
  };

  buildInputs = [ libuuid popt icu ncurses ];

  installPhase = ''
    mkdir -p $out/sbin
    mkdir -p $out/share/man/man8
    for prog in gdisk sgdisk fixparts cgdisk
    do
        install -v -m755 $prog $out/sbin
        install -v -m644 $prog.8 $out/share/man/man8
    done
  '';

  meta = {
    description = "A set of text-mode partitioning tools for Globally Unique Identifier (GUID) Partition Table (GPT) disks";

    license = "GPLv2";

    homepage = http://www.rodsbooks.com/gdisk/;

    maintainers = [ stdenv.lib.maintainers.shlevy ];

    platforms = stdenv.lib.platforms.linux;
  };
}

