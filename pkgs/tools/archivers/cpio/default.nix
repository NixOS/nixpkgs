{ lib, stdenv, fetchurl, fetchpatch }:

let
  version = "2.13";
  name = "cpio-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/cpio/${name}.tar.bz2";
    sha256 = "0vbgnhkawdllgnkdn6zn1f56fczwk0518krakz2qbwhxmv2vvdga";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-38185.patch";
      url = "https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=dd96882877721703e19272fe25034560b794061b";
      sha256 = "0vmr0qjwj2ldnzsvccl105ckwgx3ssvn9mp3f27ss0kiyigrzz32";
    })
  ];

  preConfigure = if stdenv.isCygwin then ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '' else null;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/cpio/";
    description = "A program to create or extract from cpio archives";
    license = licenses.gpl3;
    platforms = platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
  };
}
