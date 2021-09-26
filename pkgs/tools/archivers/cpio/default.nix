{ lib, stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "cpio";
  version = "2.13";

  src = fetchurl {
    url = "mirror://gnu/cpio/cpio-${version}.tar.bz2";
    sha256 = "0vbgnhkawdllgnkdn6zn1f56fczwk0518krakz2qbwhxmv2vvdga";
  };

  patches = let
    fp = suffix: rev: sha256: fetchpatch {
      name = "CVE-2021-38185-${suffix}.patch";
      url = "https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=${rev}";
      inherit sha256;
    };
  in [
    (fp "1" "dd96882877721703e19272fe25034560b794061b"
        "0vmr0qjwj2ldnzsvccl105ckwgx3ssvn9mp3f27ss0kiyigrzz32")
    (fp "2" "dfc801c44a93bed7b3951905b188823d6a0432c8"
        "1qkrhi3lbxk6hflp6w3h4sgssc0wblv8r0qgxqzbjrm36pqwxiwh")
    (fp "3" "236684f6deb3178043fe72a8e2faca538fa2aae1"
        "0pidkbxalpj5yz4fr95x8h0rizgjij0xgvjgirfkjk460giawwg6")
    (fetchpatch {
      # upstream build fix against -fno-common compilers like >=gcc-10
      name = "fno-common-fix.patch";
      url = "https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=641d3f489cf6238bb916368d4ba0d9325a235afb";
      sha256 = "1ffawzxjw72kzpdwffi2y7pvibrmwf4jzrxdq9f4a75q6crl66iq";
    })
  ];

  preConfigure = lib.optionalString stdenv.isCygwin ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/cpio/";
    description = "A program to create or extract from cpio archives";
    license = licenses.gpl3;
    platforms = platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
  };
}
