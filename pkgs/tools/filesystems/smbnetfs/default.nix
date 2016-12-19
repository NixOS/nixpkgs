{ stdenv, fetchurl, fuse, samba, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "smbnetfs-${version}";
  version = "0.6.0";
  src = fetchurl {
    url = "mirror://sourceforge/project/smbnetfs/smbnetfs/SMBNetFS-${version}/${name}.tar.bz2";
    sha256 = "16sikr81ipn8v1a1zrqgnsy2as3zcaxbzkr0bm5vxy012bq0plkd";
  };

  buildInputs = [ fuse samba pkgconfig glib ];

  meta = with stdenv.lib; {
    description = "A FUSE FS for mounting Samba shares";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    downloadPage = "http://sourceforge.net/projects/smbnetfs/files/smbnetfs";
    updateWalker = true;
    inherit version;
    homepage = http://sourceforge.net/projects/smbnetfs/;
  };
}
