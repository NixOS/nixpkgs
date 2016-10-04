{ stdenv, fetchurl, pkgconfig, fuse, libarchive }:

let
  name = "archivemount-0.8.3";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.cybernoia.de/software/archivemount/${name}.tar.gz";
    sha256 = "1zv1fvik76kpp1q5f2dz01f4fwg1m5a8rl168px47jy9nyl9k277";
  };

  buildInputs = [ pkgconfig fuse libarchive ];

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
