{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fnotifystat";
  version = "0.02.06";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/fnotifystat/fnotifystat-${version}.tar.gz";
    sha256 = "1mr2qzh8r8qq7haz4qgci2k5lcrcy493fm0m3ri40a81vaajfniy";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "File activity monitoring tool";
    homepage = "https://kernel.ubuntu.com/~cking/fnotifystat/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
