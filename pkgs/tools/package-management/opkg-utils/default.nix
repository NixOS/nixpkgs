{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "opkg-utils-20141030";

  # No releases, only a git tree
  src = fetchgit {
    url = "git://git.yoctoproject.org/opkg-utils";
    rev = "762d9dadce548108d4204c2113461a7dd6f57e60";
    sha256 = "09jfkq2p5wv0ifxkw62f4m7pkvpaalh74j2skymi8lh4268krfwz";
  };

  preBuild = ''
    makeFlagsArray+=(PREFIX="$out")
  '';

  meta = with stdenv.lib; {
    description = "Helper scripts for use with the opkg package manager";
    homepage = http://git.yoctoproject.org/cgit/cgit.cgi/opkg-utils/;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
