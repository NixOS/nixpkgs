{ fetchurl, stdenv, libuuid, popt, icu }:

stdenv.mkDerivation rec {
  name = "gptfdisk-0.7.1";

  src = fetchurl {
    url = "http://www.rodsbooks.com/gdisk/${name}.tgz";
    sha256 = "142mrlcaprh7a6r55wvaxpvjmkffh7w8lcagarmwq4cfibfrnwd8";
  };

  buildInputs = [ libuuid popt icu ];

  installPhase = ''
    ensureDir $out/bin
    ensureDir $out/share/man/man8
    install -v -m755 gdisk sgdisk fixparts $out/bin
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

