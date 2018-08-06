{ stdenv, fetchurl, libX11 }:

stdenv.mkDerivation rec {
  name = "xtrigger-${version}";
  version = "0.002";

  src = fetchurl {
    url = "https://github.com/tgharib/xtrigger/archive/${version}.tar.gz";
    sha256 = "5bb866b45c592a96787ba950cb63b28f1dc45afc6cc941b1994c2798e1e68d57";
  };

  buildInputs = [ libX11 ];
  installFlags = [ "DESTDIR=$(out)" ]; 

  postPatch = ''
    substituteInPlace Makefile --replace "/usr" "/"
  '';

  meta = with stdenv.lib; {
    description = "An X window monitor and automater";
    longDescription = "xtrigger monitors windows created by xserver and executes a command once a window 'event' is triggered.";
    homepage = https://github.com/richard-dp/xtrigger/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.taha ];
  };
}