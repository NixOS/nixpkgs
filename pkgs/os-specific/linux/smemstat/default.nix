{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "smemstat-${version}";
  version = "0.01.14";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/smemstat/smemstat-${version}.tar.gz";
    sha256 = "0qkpbg0n40d8m9jzf3ylpdp65zzs344zbjn8khha4plbwg00ijrw";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Memory usage monitoring tool";
    homepage = http://kernel.ubuntu.com/~cking/smemstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
