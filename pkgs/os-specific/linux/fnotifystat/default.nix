{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "fnotifystat-${version}";
  version = "0.01.16";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/fnotifystat/fnotifystat-${version}.tar.gz";
    sha256 = "1k9nc7a4r7c2l7vrlcrfxj9rsdb04amiqcsnxm5kpshncry38nl5";
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
