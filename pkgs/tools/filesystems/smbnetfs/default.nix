{ stdenv, fetchurl, fuse, samba, pkgconfig, glib, autoconf, attr, libsecret }:

stdenv.mkDerivation rec {
  pname = "smbnetfs";
  version = "0.6.2";
  src = fetchurl {
    url = "mirror://sourceforge/project/smbnetfs/smbnetfs/SMBNetFS-${version}/${pname}-${version}.tar.bz2";
    sha256 = "19x9978k90w9a65lrpsphk7swsq8zkws9jc27q4zbndrm0r2snr0";
  };

  nativeBuildInputs = [ pkgconfig autoconf ];
  buildInputs = [ fuse samba glib attr libsecret ];

  postPatch = ''
    substituteInPlace src/function.c --replace "attr/xattr.h" "sys/xattr.h"
  '';

  meta = with stdenv.lib; {
    description = "A FUSE FS for mounting Samba shares";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    downloadPage = "https://sourceforge.net/projects/smbnetfs/files/smbnetfs";
    updateWalker = true;
    inherit version;
    homepage = "https://sourceforge.net/projects/smbnetfs/";
  };
}
