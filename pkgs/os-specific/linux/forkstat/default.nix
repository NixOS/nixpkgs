{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "forkstat-${version}";
  version = "0.01.17";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.gz";
    sha256 = "0plm2409mmp6n2fjj6bb3z7af2cnh5lg3czlylhgaki9zd0cyb7w";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Process fork/exec/exit monitoring tool";
    homepage = http://kernel.ubuntu.com/~cking/forkstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
