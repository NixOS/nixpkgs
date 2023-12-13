{ lib, stdenv, fetchgit, autoreconfHook, libselinux, libuuid, pkg-config }:

stdenv.mkDerivation rec {
  pname = "f2fs-tools";
  version = "1.16.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-zNG1F//+BTBzlEc6qNVixyuCB6PMZD5Kf8pVK0ePYiA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libselinux libuuid ];

  patches = [ ./f2fs-tools-cross-fix.patch ];

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/";
    description = "Userland tools for the f2fs filesystem";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ehmry jagajaga ];
  };
}
