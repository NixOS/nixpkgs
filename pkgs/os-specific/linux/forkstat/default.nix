{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "forkstat";
  version = "0.02.11";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.xz";
    sha256 = "06lj8fl4083rp40i3sn8zggj165nvs3cq9dca66wcp9glb1d6yki";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  postInstall = ''
    mv $out/usr/* $out
    rm -r $out/usr
  '';
  meta = with lib; {
    description = "Process fork/exec/exit monitoring tool";
    homepage = https://kernel.ubuntu.com/~cking/forkstat/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ womfoo ];
  };
}
