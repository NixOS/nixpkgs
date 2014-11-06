{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "opkg-utils-20141030";

  # No releases, only a git tree
  src = fetchgit {
    url = "git://git.yoctoproject.org/opkg-utils";
    rev = "762d9dadce548108d4204c2113461a7dd6f57e60";
    sha256 = "a450643fa1353b872166a3d462297fb2eb240554eed7a9186645ffd72b353417";
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
