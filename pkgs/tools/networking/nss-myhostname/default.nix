{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nss-myhostname-0.3";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/nss-myhostname/${name}.tar.gz";
    sha256 = "1wnawxklsv3z796l752j7a21gvj2615fk12qr1bir3apipm499rb";
  };

  patches = [ ./nscd-segfault.patch ./ignore-ipv6-link-local.patch ];

  meta = {
    description = "Name Service Switch module ensuring that the hostname always resolves to a valid address";
    homepage = http://0pointer.de/lennart/projects/nss-myhostname/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
