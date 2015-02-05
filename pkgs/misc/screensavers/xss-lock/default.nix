{ stdenv, fetchgit, cmake, docutils, pkgconfig, glib, libpthreadstubs
, libXau, libXdmcp, xcbutil }:

stdenv.mkDerivation {
  name = "xss-lock-git";

  src = fetchgit {
    url = https://bitbucket.org/raymonad/xss-lock.git;
    rev = "d75612f1d1eea64b5c43806eea88059340a08ca9";
    sha256 = "4d57bcfd45287b5b068f45eeceb9e43d975806a038a4c586b141da5d99b3e48b";
  };

  buildInputs = [ cmake pkgconfig docutils glib libpthreadstubs libXau
                  libXdmcp xcbutil ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = with stdenv.lib; {
    description = "Use external locker (such as i3lock) as X screen saver";
    license = licenses.mit;
    maintainers = with maintainers; [ malyn ];
    platforms = platforms.linux;
  };
}
