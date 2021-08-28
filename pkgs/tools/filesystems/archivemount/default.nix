{ lib, stdenv, fetchurl, pkg-config, fuse, libarchive }:

let
  name = "archivemount-0.9.1";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "https://www.cybernoia.de/software/archivemount/${name}.tar.gz";
    sha256 = "1cy5b6qril9c3ry6fv7ir87s8iyy5vxxmbyx90dm86fbra0vjaf5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse libarchive ];

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
