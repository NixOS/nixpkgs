{ stdenv, fetchurl, fetchpatch, bison, pkgconfig, gettext, desktop-file-utils
, glib, gtk2, libxml2, libbfd, zlib, binutils, gnutls
}:

stdenv.mkDerivation rec {
  pname = "gtk-gnutella";
  version = "1.1.14";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "0sljjha4anfz1r1xq1c6qnnkjv62ld56p7xgj4bsi6lqmq1azvii";
  };

  patches = [
    (fetchpatch {
      # Avoid namespace conflict with glibc 2.28 'statx' struct / remove after v1.1.14
      url = "https://github.com/gtk-gnutella/gtk-gnutella/commit/e4205a082eb32161e28de81f5cba8095eea8ecc7.patch";
      sha256 = "0ffkw2cw2b2yhydii8jm40vd40p4xl224l8jvhimg02lgs3zfbca";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gtk-gnutella/raw/f30/f/gtk-gnutella-1.1.14-endian.patch";
      sha256 = "19q4lq8msknfz4mkbjdqmmgld16p30j2yx371p8spmr19q5i0sfn";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile.SH --replace "@exit 0" "@echo done"
  '';

  nativeBuildInputs = [ bison desktop-file-utils gettext pkgconfig ];
  buildInputs = [ binutils glib gnutls gtk2 libbfd libxml2 zlib ];

  configureScript = "./build.sh";
  configureFlags = [ "--configure-only" ];

  hardeningDisable = [ "bindnow" "fortify" "pic" "relro" ];

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm0444 src/${pname}.man $out/share/man/man1/${pname}.1
  '';

  meta = with stdenv.lib; {
    description = "A GTK Gnutella client, optimized for speed and scalability";
    homepage = "http://gtk-gnutella.sourceforge.net/"; # Code: https://github.com/gtk-gnutella/gtk-gnutella
    changelog = "https://raw.githubusercontent.com/gtk-gnutella/gtk-gnutella/v${version}/ChangeLog";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
