{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.5.2";
  name = "genromfs-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/romfs/genromfs/${version}/${name}.tar.gz";
    sha256 = "0q6rpq7cmclmb4ayfyknvzbqysxs4fy8aiahlax1sb2p6k3pzwrh";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "prefix = /usr" "prefix = $out" \
      --replace "gcc" "cc"
  '';

  meta = with stdenv.lib; {
    homepage = http://romfs.sourceforge.net/;
    description = "Tool for creating romfs file system images";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pxc ];
    platforms = platforms.all;
  };
}
