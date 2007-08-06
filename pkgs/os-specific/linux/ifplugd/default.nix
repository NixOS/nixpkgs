{stdenv, fetchurl, pkgconfig, libdaemon}:

stdenv.mkDerivation {
  name = "ifplugd-0.28";
  src = fetchurl {
    url = http://0pointer.de/lennart/projects/ifplugd/ifplugd-0.28.tar.gz;
    sha256 = "1w21cpyzkr7igp6vsf4a0jwp2b0axs3kwjiapy676bdk9an58is7";
  };
  buildInputs = [pkgconfig libdaemon];
  configureFlags = "--with-initdir=$out/etc/init.d --disable-lynx";
  patches = [
    (fetchurl {
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/sys-apps/ifplugd/files/ifplugd-0.28-interface.patch?rev=1.1";
      sha256 = "0rxwy7l7vwxz9gy0prfb93x2ycxaz3r203rhbwmbwrzl4rzy3nqv";
    })
  ];
  patchFlags = "-p0";
}
