{ stdenv, fetchurl, gcc, cmake, git }:
stdenv.mkDerivation rec {
  name = "j4-dmenu-desktop-${version}";
  version = "2.13";

  src = fetchurl {
    url = https://github.com/enkore/j4-dmenu-desktop/archive/r2.13.tar.gz;
    sha256 = "10gzi60gcjr2w19dh391mcyvfskajwsk83dxzarp2hhww1jbrixh";
  };

  cmakeFlags = [ "-DNO_TESTS=True" ];

  installPhase = ''
    make install
    mkdir -p $out/share/man/man1
    mv ../j4-dmenu-desktop.1 $out/share/man/man1/
  '';

  meta = {
    description = "A fast desktop menu";
    longDescription = ''
      j4-dmenu-desktop is a replacement for i3-dmenu-desktop. It's purpose is to find .desktop files
      and offer you a menu to start an application using dmenu. Since r2.7 j4-dmenu-desktop doesn't
      require i3wm anymore and should work just fine on about any desktop environment.
    '';
    homepage = https://github.com/enkore/j4-dmenu-desktop;
    maintainers = [ stdenv.lib.maintainers.aaronschif ];
  };
}
