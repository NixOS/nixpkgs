{ stdenv, fetchurl, fuse, pkgconfig, attr, uthash }:

stdenv.mkDerivation rec {
  pname = "mhddfs";
  version = "0.1.39";

  src = fetchurl {
    url = "http://mhddfs.uvw.ru/downloads/mhddfs_${version}.tar.gz";
    sha256 = "14ggmh91vv69fp2qpz0nxp0hprlw2wsijss2k2485hb0ci4cabvh";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse attr uthash ];

  patches = [
    ./fix-format-security-error.patch
  ];

  postPatch = ''
    substituteInPlace src/main.c --replace "attr/xattr.h" "sys/xattr.h"
    substituteInPlace src/tools.c --replace "attr/xattr.h" "sys/xattr.h"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp mhddfs $out/bin/
  '';

  meta = {
    homepage = "http://mhddfs.uvw.ru/";
    description = "Combines a several mount points into the single one";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.makefu ];
  };
}
