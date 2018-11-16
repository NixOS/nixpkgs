{ stdenv, fetchurl, fetchpatch }:

let
  version = "2.12";
  name = "cpio-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/cpio/${name}.tar.bz2";
    sha256 = "0vi9q475h1rki53100zml75vxsykzyhrn70hidy41s5c2rc8r6bh";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2015-1197-cpio-2.12.patch";
      url = "https://gist.github.com/nckx/70b0bfa80ddfb86c2967/"
        + "raw/e9b40d4d4b701f584f826775b75beb10751dc884/"
        + "CVE-2015-1197-cpio-2.12.patch";
      sha256 = "0ph43m4lavwkc4gnl5h9p3da4kb1pnhwk5l2qsky70dqri8pcr8v";
    })

    # Report: http://www.openwall.com/lists/oss-security/2016/01/19/4
    # Patch from https://lists.gnu.org/archive/html/bug-cpio/2016-01/msg00005.html
    ./CVE-2016-2037-out-of-bounds-write.patch
  ];

  preConfigure = if stdenv.isCygwin then ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '' else null;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/cpio/;
    description = "A program to create or extract from cpio archives";
    license = licenses.gpl3;
    platforms = platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
  };
}
