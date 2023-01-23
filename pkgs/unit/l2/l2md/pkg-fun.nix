{ lib, stdenv, fetchgit, libgit2 }:

stdenv.mkDerivation rec {
  pname = "l2md";
  version = "unstable-2021-10-27";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/l2md.git";
    rev = "9db252bc1716ebaf0abd3a47a59ea78e4e6253d6";
    sha256 = "sha256-H/leDUwQM55akyXsmTnI2YsnG4i1KQtf4bBt1fizy8E=";
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
