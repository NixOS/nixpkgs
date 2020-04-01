{ stdenv, fetchurl, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "squid-4.10";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v4/${name}.tar.xz";
    sha256 = "07sz0adv8nkhy797675bpra7lvdkwjq9isw1ddgylhlazl511w4q";
  };

  nativeBuildInputs = [ pkgconfig ];
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
    maintainers = with maintainers; [ fpletz raskin ];
  };
}
