{ lib, stdenv, fetchgit, autoreconfHook, libselinux, libuuid, pkg-config }:

stdenv.mkDerivation rec {
  pname = "f2fs-tools";
  version = "1.14.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git";
    rev = "refs/tags/v${version}";
    sha256 = "06ss05n87i1c3149qb3n7j1qp2scv3g2adx0v6ljkl59ab9b5saj";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libselinux libuuid ];

  patches = [ ./f2fs-tools-cross-fix.patch ];

  meta = with lib; {
    homepage = "http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/";
    description = "Userland tools for the f2fs filesystem";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ehmry jagajaga ];
  };
}
