{ stdenv, fetchurl, fuse, samba, pkgconfig, glib, autoconf, attr, libsecret }:

stdenv.mkDerivation rec {
  name = "smbnetfs-${version}";
  version = "0.6.1";
  src = fetchurl {
    url = "mirror://sourceforge/project/smbnetfs/smbnetfs/SMBNetFS-${version}/${name}.tar.bz2";
    sha256 = "02iqjnm6pdwc1q38z56akiwdbp0xisr6qwrmxs1lrk5mq7j8x2w4";
  };

  nativeBuildInputs = [ pkgconfig autoconf ];
  buildInputs = [ fuse samba glib attr libsecret ];

  meta = with stdenv.lib; {
    description = "A FUSE FS for mounting Samba shares";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    downloadPage = "https://sourceforge.net/projects/smbnetfs/files/smbnetfs";
    updateWalker = true;
    inherit version;
    homepage = https://sourceforge.net/projects/smbnetfs/;
  };
}
