{ stdenv, fetchurl, pkgconfig, libpipeline, db, groff }:

stdenv.mkDerivation rec {
  name = "man-db-2.7.5";

  src = fetchurl {
    url = "mirror://savannah/man-db/${name}.tar.xz";
    sha256 = "056a3il7agfazac12yggcg4gf412yq34k065im0cpfxbcw6xskaw";
  };

  buildInputs = [ pkgconfig libpipeline db groff ];

  configureFlags = [
    "--disable-setuid"
    "--sysconfdir=\${out}/etc"
    "--localstatedir=/var"
    "--with-systemdtmpfilesdir=\${out}/lib/tmpfiles.d"
    "--with-eqn=${groff}/bin/eqn"
    "--with-neqn=${groff}/bin/neqn"
    "--with-nroff=${groff}/bin/nroff"
    "--with-pic=${groff}/bin/pic"
    "--with-refer=${groff}/bin/refer"
    "--with-tbl=${groff}/bin/tbl"
  ];

  installFlags = [ "DESTDIR=\${out}" ];

  postInstall = ''
    mv $out/$out/* $out
    DIR=$out/$out
    while rmdir $DIR 2>/dev/null; do
      DIR="$(dirname "$DIR")"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://man-db.nongnu.org";
    description = "An implementation of the standard Unix documentation system accessed using the man command";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
