{ fetchurl, stdenv, libuuid, popt, icu, ncurses }:

stdenv.mkDerivation rec {
  name = "gptfdisk-0.8.5";

  src = fetchurl {
    url = "mirror://sourceforge/gptfdisk/${name}.tar.gz";
    sha256 = "1yaax2mga7n847x1ihbgvv4drzvndgnn4mii0mz1ab1150gnkk0m";
  };

  buildInputs = [ libuuid popt icu ncurses ];

  installPhase = ''
    mkdir -p $out/sbin
    mkdir -p $out/share/man/man8
    install -v -m755 gdisk sgdisk fixparts $out/sbin
    install -v -m644 gdisk.8 sgdisk.8 fixparts.8 \
        $out/share/man/man8
  '';

  meta = {
    description = "A set of text-mode partitioning tools for Globally Unique Identifier (GUID) Partition Table (GPT) disks";

    license = "GPLv2";

    homepage = http://www.rodsbooks.com/gdisk/;

    maintainers = stdenv.lib.maintainers.shlevy;
    platforms = stdenv.lib.platforms.linux;
  };
}

