{ stdenv, fetchurl, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl }:

stdenv.mkDerivation rec {
  name = "squid-3.5.23";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v3/3.5/${name}.tar.xz";
    sha256 = "1nqbljph2mbxjy1jzsis5vplfvvc2y6rdlxy609zx4hyyjchqk7s";
  };

  buildInputs = [
    perl openldap pam db cyrus_sasl libcap expat libxml2 openssl
  ];

  configureFlags = [
    "--enable-ipv6"
    "--disable-strict-error-checking"
    "--disable-arch-native"
    "--with-openssl"
    "--enable-ssl-crtd"
    "--enable-linux-netfilter"
    "--enable-storeio=ufs,aufs,diskd,rock"
    "--enable-removal-policies=lru,heap"
    "--enable-delay-pools"
    "--enable-x-accelerator-vary"
  ];

  meta = with stdenv.lib; {
    description = "A caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = "http://www.squid-cache.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
