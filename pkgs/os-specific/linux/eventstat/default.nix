{ stdenv, lib, fetchzip, ncurses }:

stdenv.mkDerivation rec {
  name = "eventstat-${version}";
  version = "0.03.03";
  src = fetchzip {
    url = "http://kernel.ubuntu.com/~cking/tarballs/eventstat/eventstat-${version}.tar.gz";
    sha256 = "02pg46f3x7v1c1vvqzfjqq0wjb2bzmfkd6a8xp06cg9zvidn6jpb";
  };
  buildInputs = [ ncurses ];
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Simple monitoring of system events";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
