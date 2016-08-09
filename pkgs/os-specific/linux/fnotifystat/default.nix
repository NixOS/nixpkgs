{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "fnotifystat-${version}";
  version = "0.01.14";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/fnotifystat/fnotifystat-${version}.tar.gz";
    sha256 = "1cc3w94v8b4nfpkgr33gfzxpwaf43brqyc0fla9p70gk3hxjqzi5";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "File activity monitoring tool";
    homepage = http://kernel.ubuntu.com/~cking/fnotifystat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
