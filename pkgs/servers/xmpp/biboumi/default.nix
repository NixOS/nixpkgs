{ stdenv, fetchurl, fetchgit, cmake, libuuid, expat, sqlite, libidn,
  libiconv, botan2, systemd, pkgconfig, udns, pandoc, coreutils } :

stdenv.mkDerivation rec {
  pname = "biboumi";
  version = "8.5";

  src = fetchurl {
    url = "https://git.louiz.org/biboumi/snapshot/biboumi-${version}.tar.xz";
    sha256 = "0rn9p99iqdyvxjzjq9w0ra7pkk0mngjy65nlg3hqfdw8kq9mv5qf";
  };

  louiz_catch = fetchgit {
    url = "https://lab.louiz.org/louiz/Catch.git";
    rev = "0a34cc201ef28bf25c88b0062f331369596cb7b7"; # v2.2.1
    sha256 = "0ad0sjhmzx61a763d2ali4vkj8aa1sbknnldks7xlf4gy83jfrbl";
  };

  patches = [ ./catch.patch ];

  nativeBuildInputs = [ cmake pkgconfig pandoc ];
  buildInputs = [ libuuid expat sqlite libiconv libidn botan2 systemd
    udns ];

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc/biboumi $out/etc/biboumi
    cp $louiz_catch/single_include/catch.hpp tests/
  '';

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Modern XMPP IRC gateway";
    platforms = platforms.unix;
    homepage = "https://lab.louiz.org/louiz/biboumi";
    license = licenses.zlib;
    maintainers = [ maintainers.woffs ];
  };
}
