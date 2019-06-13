{ stdenv, fetchurl, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl }:

stdenv.mkDerivation rec {
  name = "squid-3.5.28";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v3/3.5/${name}.tar.xz";
    sha256 = "1n4f55g56b11qz4fazrnvgzx5wp6b6637c4qkbd1lrjwwqibchgx";
  };

  buildInputs = [
    perl openldap db cyrus_sasl expat libxml2 openssl
  ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap pam ];

  configureFlags = [
    "--enable-ipv6"
    "--disable-strict-error-checking"
    "--disable-arch-native"
    "--with-openssl"
    "--enable-ssl-crtd"
    "--enable-storeio=ufs,aufs,diskd,rock"
    "--enable-removal-policies=lru,heap"
    "--enable-delay-pools"
    "--enable-x-accelerator-vary"
  ] ++ stdenv.lib.optional (stdenv.isLinux && !stdenv.hostPlatform.isMusl) "--enable-linux-netfilter";

  meta = with stdenv.lib; {
    description = "A caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = http://www.squid-cache.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
