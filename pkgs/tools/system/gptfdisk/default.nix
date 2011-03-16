{ fetchurl, stdenv, libuuid, popt }:

stdenv.mkDerivation rec {
  name = "gptfdisk-0.7.0";

  src = fetchurl {
    url = "http://www.rodsbooks.com/gdisk/${name}.tgz";
    sha256 = "1912l01pj7wcaj2fp06yl6m893c52qh2qy0bkx33k6iq2k747zrf";
  };

  buildInputs = [ libuuid popt ];

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
