{ fetchurl, fetchpatch, stdenv }:

stdenv.mkDerivation rec {
  name = "xinetd-2.3.15";

  src = fetchurl {
    url = "http://www.xinetd.org/${name}.tar.gz";
    sha256 = "1qsv1al506x33gh92bqa8w21k7mxqrbsrwmxvkj0amn72420ckmz";
  };

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-apps/xinetd/files/xinetd-2.3.15-creds.patch?id=426002bfe2789fb6213fba832c8bfee634d68d02";
      name = "CVE-2013-4342.patch";
      sha256 = "1iqcrqzgisz4b6vamprzg2y6chai7qpifqcihisrwbjwbc4wzj8v";
    })
  ];

  meta = {
    description = "Secure replacement for inetd";
    platforms = stdenv.lib.platforms.linux;
    homepage = http://xinetd.org;
    license = stdenv.lib.licenses.free;
  };
}
