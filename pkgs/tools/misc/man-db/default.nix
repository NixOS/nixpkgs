{ stdenv, fetchurl, pkgconfig, libpipeline, db, groff }:
 
stdenv.mkDerivation rec {
  name = "man-db-2.6.6";
  
  src = fetchurl {
    url = "mirror://savannah/man-db/${name}.tar.xz";
    sha256 = "1hv6byj6sg6cp3jyf08gbmdm4pwhvd5hzmb94xl0w7prin6hzabx";
  };
  
  buildInputs = [ pkgconfig libpipeline db groff ];
  
  configureFlags = ''
    --disable-setuid
  '';

  meta = with stdenv.lib; {
    homepage = "http://man-db.nongnu.org";
    description = "An implementation of the standard Unix documentation system accessed using the man command";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
