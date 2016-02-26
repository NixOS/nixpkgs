{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation {
  name = "cpio-2.11";

  src = fetchurl {
    url = mirror://gnu/cpio/cpio-2.11.tar.bz2;
    sha256 = "bb820bfd96e74fc6ce43104f06fe733178517e7f5d1cdee553773e8eff7d5bbd";
  };

  patches = [
    ./no-gets.patch
    (fetchpatch {
      name = "CVE-2014-9112.diff";
      url = "http://pkgs.fedoraproject.org/cgit/cpio.git/plain/cpio-2.11"
        + "-CVE-2014-9112.patch?h=f21&id=b475b4d6f31c95e073edc95c742a33a39ef4ec95";
      sha256 = "0c9yrysvpwbmiq7ph84dk6mv46hddiyvkgya1zsmj76n9ypb1b4i";
    })

    # Report: http://www.openwall.com/lists/oss-security/2016/01/19/4
    # Patch from https://lists.gnu.org/archive/html/bug-cpio/2016-01/msg00005.html
    ./CVE-2016-2037-out-of-bounds-write.patch
  ] ++ stdenv.lib.optional stdenv.isDarwin ./darwin-fix.patch;

  postPatch = let pp =
    fetchpatch {
      name = "CVE-2015-1197.diff";
      url = "https://marc.info/?l=oss-security&m=142289947619786&w=2";
      sha256 = "0fr95bj416zfljv40fl1sh50059d18wdmfgaq8ad2fqi5cnbk859";
    };
    # one "<" and one "&" sign get mangled in the patch
    in "cat ${pp} | sed 's/&lt;/</;s/&amp;/\\&/' | patch -p1";

  preConfigure = if stdenv.isCygwin then ''
    sed -i gnu/fpending.h -e 's,include <stdio_ext.h>,,'
  '' else null;

  meta = {
    homepage = http://www.gnu.org/software/cpio/;
    description = "A program to create or extract from cpio archives";
    platforms = stdenv.lib.platforms.all;
    priority = 6; # resolves collision with gnutar's "libexec/rmt"
  };
}
