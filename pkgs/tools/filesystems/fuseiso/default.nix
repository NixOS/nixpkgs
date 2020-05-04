{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, fuse, glib, zlib }:

stdenv.mkDerivation rec {
  pname = "fuseiso";
  version = "20070708";

  src = fetchurl {
    url = "mirror://sourceforge/project/fuseiso/fuseiso/${version}/fuseiso-${version}.tar.bz2";
    sha256 = "127xql52dcdhmh7s5m9xc6q39jdlj3zhbjar1j821kb6gl3jw94b";
  };

  patches = map (p:
    fetchpatch {
      inherit (p) name sha256;
      url = "https://sources.debian.net/data/main/f/fuseiso/${version}-3.2/debian/patches/${p.name}";
    }) [
    {
      name = "00-support_large_iso.patch";
      sha256 = "1lmclb1qwzz5f4wlq693g83bblwnjjl73qhgfxbsaac5hnn2shjw";
    }
    {
      name = "01-fix_typo.patch";
      sha256 = "14rpxp0yylzsgqv0r19l4wx1h5hvqp617gpv1yg0w48amr9drasa";
    }
    { # CVE-2015-8837
      name = "02-prevent-buffer-overflow.patch";
      sha256 = "1ls2pp3mh91pdb51qz1fsd8pwhbky6988bpd156bn7wgfxqzh8ig";
    }
    { # CVE-2015-8836
      name = "03-prevent-integer-overflow.patch";
      sha256 = "100cw07fk4sa3hl7a1gk2hgz4qsxdw99y20r7wpidwwwzy463zcv";
    }
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ fuse glib zlib ];

  # after autoreconfHook, glib and zlib are not found, so force link against
  # them
  NIX_LDFLAGS = "-lglib-2.0 -lz";

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} NEWS README
  '';

  meta = with stdenv.lib; {
    description = "FUSE module to mount ISO filesystem images";
    homepage = "https://sourceforge.net/projects/fuseiso";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
