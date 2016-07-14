{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "forkstat-${version}";
  version = "0.01.13";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.gz";
    sha256 = "12dmqpv0q3x166sya93rhcj7vs4868x7y7lwfwv9l54hhirpamhq";
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
