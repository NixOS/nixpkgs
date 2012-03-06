{ fetchurl, stdenv, libuuid, popt, icu, ncurses }:

stdenv.mkDerivation rec {
  name = "gptfdisk-0.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/gptfdisk/${name}.tar.gz";
    sha256 = "096qmlqcsvjklihggwphdmd0y78jz4ghf7gf4fvjnskp7mg4ng31";
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

