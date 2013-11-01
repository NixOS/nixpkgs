{ fetchurl, stdenv, libuuid, popt, icu, ncurses }:

stdenv.mkDerivation rec {
  name = "gptfdisk-0.8.6";

  src = fetchurl {
    url = "mirror://sourceforge/gptfdisk/${name}.tar.gz";
    sha256 = "1cj7lribq8f3i4q6463q08bs42pvlzfj0iz2f2cnjn94hiacsya5";
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

    maintainers = stdenv.lib.maintainers.shlevy;

    platforms = stdenv.lib.platforms.linux;
  };
}

