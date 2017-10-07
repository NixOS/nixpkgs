{ stdenv, fetchurl, cmake, libuuid, expat, sqlite, git, libidn,
  libiconv, botan2, systemd, pkgconfig, udns } :

stdenv.mkDerivation rec {
  name = "biboumi-${version}";
  version = "6.1";

  src = fetchurl {
    url = "https://git.louiz.org/biboumi/snapshot/biboumi-${version}.tar.xz";
    sha256 = "1la1n502v2wyfm0vl8v4m0hbigkkjchi21446n9mb203fz1cvr77";
  };

  buildInputs = [ cmake libuuid expat sqlite git libiconv libidn botan2
    systemd pkgconfig udns ];

  preConfigure = ''
    grep -lr /etc/biboumi . | while read f
    do
      substituteInPlace $f --replace /etc/biboumi $out/etc/biboumi
    done
  '';

  meta = with stdenv.lib; {
    description = "Modern XMPP IRC gateway";
    platforms = platforms.unix;
    homepage = https://lab.louiz.org/louiz/biboumi;
    license = licenses.zlib;
  };
}
