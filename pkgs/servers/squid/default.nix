{ lib, stdenv, fetchurl, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "squid";
  version = "4.15";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v4/${pname}-${version}.tar.xz";
    sha256 = "sha256-tpOk5asoEaioVPYN4KYq+786lSux0EeVLJrgEyH4SiU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    perl openldap db cyrus_sasl expat libxml2 openssl
  ] ++ lib.optionals stdenv.isLinux [ libcap pam ];

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
  ] ++ lib.optional (stdenv.isLinux && !stdenv.hostPlatform.isMusl) "--enable-linux-netfilter";

  meta = with lib; {
    description = "A caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = "http://www.squid-cache.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz raskin ];
  };
}
