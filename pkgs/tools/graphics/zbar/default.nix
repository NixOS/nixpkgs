{ stdenv, fetchurl, imagemagickBig, pkgconfig, python, pygtk, perl
, libX11, libv4l, qt4, lzma, gtk2, fetchpatch, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "zbar";
  version = "0.10";
  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${version}/${name}.tar.bz2";
    sha256 = "1imdvf5k34g1x2zr6975basczkz3zdxg6xnci50yyp5yvcwznki3";
  };

  patches = [
    (fetchpatch {
      name = "0001-Description-Linux-2.6.38-and-later-do-not-support-th.patch";
      url = "https://git.recluse.de/raw/debian/pkg-zbar.git/35182c3ac2430c986579b25f1826fe1b7dfd15de/debian!patches!0001-Description-Linux-2.6.38-and-later-do-not-support-th.patch";
      sha256 = "1zy1wdyhmpw877pv6slfhjy0c6dm0gxli0i4zs1akpvh052j4a69";
    })
    (fetchpatch {
      name = "python-zbar-import-fix-am.patch";
      url = "https://git.recluse.de/raw/debian/pkg-zbar.git/1f15f52e53ee0bf7b4761d673dc859c6b10e6be5/debian!patches!python-zbar-import-fix-am.patch";
      sha256 = "15xx9ms137hvwpynbgvbc6zgmmzfaf7331rfhls24rgbnywbgirx";
    })
    (fetchpatch {
      name = "new_autotools_build_fix.patch";
      url = "https://git.recluse.de/raw/debian/pkg-zbar.git/2c641cc94d4f728421ed750d95d6d1c2d06a534d/debian!patches!new_autotools_build_fix.patch";
      sha256 = "0jhl5jnnjhfdv51xqimkbkdvj8d38z05fhd11yx1sgmw82f965s3";
    })
    (fetchpatch {
      name = "threading-fix.patch";
      url = "https://git.recluse.de/raw/debian/pkg-zbar.git/d3eba6e2c3acb0758d19519015bf1a53ffb8e645/debian!patches!threading-fix.patch";
      sha256 = "1jjgrx9nc7788vfriai4z26mm106sg5ylm2w5rdyrwx7420x1wh7";
    })
  ];

  buildInputs =
    [ imagemagickBig pkgconfig python pygtk perl libX11
      libv4l qt4 lzma gtk2 autoreconfHook ];

  hardeningDisable = [ "fortify" ];

  meta = with stdenv.lib; {
    description = "Bar code reader";
    longDescription = ''
      ZBar is an open source software suite for reading bar codes from various
      sources, such as video streams, image files and raw intensity sensors. It
      supports many popular symbologies (types of bar codes) including
      EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Interleaved 2 of 5 and QR
      Code.
    '';
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
    homepage = http://zbar.sourceforge.net/;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://zbar.sourceforge.net/";
    };
  };
}
