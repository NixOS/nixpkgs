{ lib, stdenv, fetchgit, libgit2 }:

stdenv.mkDerivation rec {
  pname = "l2md";
  version = "unstable-2020-07-31";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/l2md.git";
    rev = "2b9fae141fc2129940e0337732a35a3fc1c33455";
    sha256 = "PNNoD3a+rJwKH6wbOkvVU1IW4+xF7+zQaLFAlyLlYOI=";
  };

  buildInputs = [ libgit2 ];

  installPhase = ''
    mkdir -p $out/bin
    cp l2md $out/bin
  '';

  meta = with lib; {
    description = "Convert public-inbox archives to maildir messages";
    longDescription = ''
      Quick and dirty hack to import lore.kernel.org list archives via git,
      to export them in maildir format or through a pipe, and to keep them
      periodically synced.
    '';
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/l2md.git";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ yoctocell ];
    platforms = platforms.unix;
  };
}
