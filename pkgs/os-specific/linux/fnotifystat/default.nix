{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "fnotifystat-${version}";
  version = "0.01.17";
  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/fnotifystat/fnotifystat-${version}.tar.gz";
    sha256 = "0ncfbrpyb3ak49nrdr4cb3w082n9s181lizfqx51zi9rdgkj1vm3";
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
