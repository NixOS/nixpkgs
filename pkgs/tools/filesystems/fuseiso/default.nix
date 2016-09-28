{ stdenv, fetchurl, fetchpatch, pkgconfig, fuse, zlib, glib }:

stdenv.mkDerivation rec {
  name = "fuseiso-20070708";

  src = fetchurl {
    url = "mirror://sourceforge/project/fuseiso/fuseiso/20070708/fuseiso-20070708.tar.bz2";
    sha256 = "127xql52dcdhmh7s5m9xc6q39jdlj3zhbjar1j821kb6gl3jw94b";
  };

  buildInputs = [ pkgconfig fuse zlib glib ];

  patches = let fetchPatchFromDebian = { patch, sha256 }:
    fetchpatch {
      inherit sha256;
      url = "https://sources.debian.net/data/main/f/fuseiso/20070708-3.2/debian/patches/${patch}";
    };
  in [
    (fetchPatchFromDebian {
      patch = "00-support_large_iso.patch";
      sha256 = "1lmclb1qwzz5f4wlq693g83bblwnjjl73qhgfxbsaac5hnn2shjw";
    })
    (fetchPatchFromDebian { # CVE-2015-8837
      patch = "02-prevent-buffer-overflow.patch";
      sha256 = "1ls2pp3mh91pdb51qz1fsd8pwhbky6988bpd156bn7wgfxqzh8ig";
    })
    (fetchPatchFromDebian { # CVE-2015-8836
      patch = "03-prevent-integer-overflow.patch";
      sha256 = "100cw07fk4sa3hl7a1gk2hgz4qsxdw99y20r7wpidwwwzy463zcv";
    })
  ];

  meta = {
    homepage = http://sourceforge.net/projects/fuseiso;
    description = "FUSE module to mount ISO filesystem images";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
