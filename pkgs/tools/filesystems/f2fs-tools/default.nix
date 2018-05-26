{ stdenv, fetchgit, autoreconfHook, libselinux, libuuid, pkgconfig }:

stdenv.mkDerivation rec {
  name = "f2fs-tools-${version}";
  version = "1.9.0";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git";
    rev = "refs/tags/v${version}";
    sha256 = "0aj9dbhv7vv19pyb2rhcg99v5v0s66sb9yzrdmi46bmvzz124pal";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libselinux libuuid ];

  meta = with stdenv.lib; {
    homepage = http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/;
    description = "Userland tools for the f2fs filesystem";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ehmry jagajaga ];
  };
}
