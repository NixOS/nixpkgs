{ stdenv, fetchurl, pkgconfig, libpipeline, db
, groff, less, gzip, bzip2, xz}:
 
stdenv.mkDerivation rec {
  name = "man-db-2.7.2";
  
  src = fetchurl {
    url = "mirror://savannah/man-db/${name}.tar.xz";
    sha256 = "14p4sr57qc02gfnpybcnv33fb7gr266iqsyq7z4brs6wa6plwrr2";
  };
  
  buildInputs = [ pkgconfig libpipeline db groff
                less gzip bzip2 xz ];
  
  configureFlags = [
    "--disable-setuid"
    "--sysconfdir=\${out}/etc"
    "--localstatedir=/var"
    "--with-systemdtmpfilesdir=\${out}/lib/tmpfiles.d"
    "--with-pager=${less}/bin/less"
    "--with-gzip=${gzip}/bin/gzip"
    "--with-bzip2=${bzip2}/bin/bzip2"
    "--with-xz=${xz}/bin/xz"
  ] ++ map (exe: "--with-" + exe + "=${groff}/bin/" + exe) [ "nroff" "eqn" "neqn" "tbl" "refer" "pic"];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "http://man-db.nongnu.org";
    description = "An implementation of the standard Unix documentation system accessed using the man command";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
