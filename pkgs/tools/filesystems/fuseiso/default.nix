{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook, pkg-config, fuse, glib, zlib }:

stdenv.mkDerivation rec {
  pname = "fuseiso";
  version = "20070708";

  src = fetchurl {
    url = "mirror://sourceforge/project/fuseiso/fuseiso/${version}/fuseiso-${version}.tar.bz2";
    sha256 = "127xql52dcdhmh7s5m9xc6q39jdlj3zhbjar1j821kb6gl3jw94b";
  };

  patches = [
    (fetchpatch {
      name = "00-support_large_iso.patch";
      url = "https://sources.debian.net/data/main/f/fuseiso/${version}-3.2/debian/patches/00-support_large_iso.patch";
      sha256 = "1lmclb1qwzz5f4wlq693g83bblwnjjl73qhgfxbsaac5hnn2shjw";
    })
    (fetchpatch {
      name = "01-fix_typo.patch";
      url = "https://sources.debian.net/data/main/f/fuseiso/${version}-3.2/debian/patches/01-fix_typo.patch";
      sha256 = "14rpxp0yylzsgqv0r19l4wx1h5hvqp617gpv1yg0w48amr9drasa";
    })
    (fetchpatch {
      name = "02-prevent-buffer-overflow_CVE-2015-8837.patch";
      url = "https://sources.debian.net/data/main/f/fuseiso/${version}-3.2/debian/patches/02-prevent-buffer-overflow.patch";
      sha256 = "1ls2pp3mh91pdb51qz1fsd8pwhbky6988bpd156bn7wgfxqzh8ig";
    })
    (fetchpatch {
      name = "03-prevent-integer-overflow_CVE-2015-8836.patch";
      url = "https://sources.debian.net/data/main/f/fuseiso/${version}-3.2/debian/patches/03-prevent-integer-overflow.patch";
      sha256 = "100cw07fk4sa3hl7a1gk2hgz4qsxdw99y20r7wpidwwwzy463zcv";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ fuse glib zlib ];

  # after autoreconfHook, glib and zlib are not found, so force link against
  # them
  NIX_LDFLAGS = "-lglib-2.0 -lz";

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} NEWS README
  '';

  meta = with lib; {
    description = "FUSE module to mount ISO filesystem images";
    homepage = "https://sourceforge.net/projects/fuseiso";
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "fuseiso";
  };
}
