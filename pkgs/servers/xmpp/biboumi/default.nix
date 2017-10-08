{ stdenv, fetchurl, fetchgit, cmake, libuuid, expat, sqlite, libidn,
  libiconv, botan2, systemd, pkgconfig, udns, pandoc, procps } :

stdenv.mkDerivation rec {
  name = "biboumi-${version}";
  version = "6.1";

  src = fetchurl {
    url = "https://git.louiz.org/biboumi/snapshot/biboumi-${version}.tar.xz";
    sha256 = "1la1n502v2wyfm0vl8v4m0hbigkkjchi21446n9mb203fz1cvr77";
  };

  louiz_catch = fetchgit {
    url = https://lab.louiz.org/louiz/Catch.git;
    rev = "35f510545d55a831372d3113747bf1314ff4f2ef";
    sha256 = "1l5b32sgr9zc2hlfr445hwwxv18sh3cn5q1xmvf588z6jyf88g2g";
  };

  patches = [ ./catch.patch ];

  nativeBuildInputs = [ cmake pkgconfig pandoc ];
  buildInputs = [ libuuid expat sqlite libiconv libidn botan2 systemd
    udns procps ];

  inherit procps;
  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace /etc/biboumi $out/etc/biboumi
    substituteInPlace unit/biboumi.service.cmake --replace /bin/kill $procps/bin/kill
    cp $louiz_catch/single_include/catch.hpp tests/
    # echo "policy_directory=$out/etc/biboumi" >> conf/biboumi.cfg
    # TODO include conf/biboumi.cfg as example somewhere
  '';

  enableParallelBuilding = true;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "Modern XMPP IRC gateway";
    platforms = platforms.unix;
    homepage = https://lab.louiz.org/louiz/biboumi;
    license = licenses.zlib;
    maintainers = [ maintainers.woffs ];
  };
}
