{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "bibclean";
<<<<<<< HEAD
  version = "3.07";

  src = fetchurl {
    url = "http://ftp.math.utah.edu/pub/bibclean/bibclean-${version}.tar.xz";
    sha256 = "sha256-kZM2eC6ePCBOYPVkhf0fjdZ562IvyP0fSDNZXuEBkaY=";
=======
  version = "3.06";

  src = fetchurl {
    url = "http://ftp.math.utah.edu/pub/bibclean/bibclean-${version}.tar.xz";
    sha256 = "sha256-ZXT5uAQrqPoF6uVBazc4o1w40Sn0jnM+JYeOz7qq3kM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace Makefile.in --replace man/man1 share/man/man1
  '';

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with lib; {
    description = "Prettyprint and syntax check BibTeX and Scribe bibliography data base files";
    homepage = "http://ftp.math.utah.edu/pub/bibclean";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
