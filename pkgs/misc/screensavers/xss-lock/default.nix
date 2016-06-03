{ stdenv, fetchgit, cmake, docutils, pkgconfig, glib, libpthreadstubs
, libXau, libXdmcp, xcbutil }:

stdenv.mkDerivation {
  name = "xss-lock-git-2014-03-02";

  src = fetchgit {
    url = https://bitbucket.org/raymonad/xss-lock.git;
    rev = "1e158fb20108058dbd62bd51d8e8c003c0a48717";
    sha256 = "10hx7k7ga8g08akwz8qrsvj8iqr5nd4siiva6sjx789jvf0sak7r";
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
