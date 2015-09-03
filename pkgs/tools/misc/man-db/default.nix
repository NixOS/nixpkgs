{ stdenv, fetchurl, pkgconfig, libpipeline, db, groff }:
 
stdenv.mkDerivation rec {
  name = "man-db-2.7.2";
  
  src = fetchurl {
    url = "mirror://savannah/man-db/${name}.tar.xz";
    sha256 = "14p4sr57qc02gfnpybcnv33fb7gr266iqsyq7z4brs6wa6plwrr2";
  };
  
  buildInputs = [ pkgconfig libpipeline db groff ];
  
  configureFlags = [
    "--disable-setuid"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdtmpfilesdir=\${out}/lib/tmpfiles.d"
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
