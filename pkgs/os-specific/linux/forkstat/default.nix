{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "forkstat";
  version = "0.02.12";
  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/forkstat/forkstat-${version}.tar.xz";
    sha256 = "0na6didnqcjn0am65qyf32a01zilk736hqlnpfyqmv4jg31r02i5";
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
