{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.5.2";
  pname = "genromfs";

  src = fetchurl {
    url = "mirror://sourceforge/romfs/genromfs/${version}/${pname}-${version}.tar.gz";
    sha256 = "0q6rpq7cmclmb4ayfyknvzbqysxs4fy8aiahlax1sb2p6k3pzwrh";
  };

  makeFlags = [
    "prefix:=$(out)"
    "CC:=$(CC)"
  ];

  meta = with lib; {
    homepage = "https://romfs.sourceforge.net/";
    description = "Tool for creating romfs file system images";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.all;
    mainProgram = "genromfs";
  };
}
