{ lib, stdenv, fetchurl, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl, pkg-config, systemd, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "squid";
  version = "5.4.1";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v5/${pname}-${version}.tar.xz";
    sha256 = "sha256-300xCpFmOuWcKbD4GD8iYjxeb3MYaa95OAWYerlMpBw=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/squid-cache/squid/security/advisories/GHSA-rcg9-7fqm-83mq
      # https://www.openwall.com/lists/oss-security/2022/09/23/1
      name = "CVE-2022-41317.patch";
      url = "http://www.squid-cache.org/Versions/v5/changesets/SQUID-2022_1.patch";
      hash = "sha256-lFX7dxEs0Gc1RFJVx5HHsslPQM8pwwAFi/W1Jc7PwK0=";
    })
    (fetchpatch {
      # https://www.openwall.com/lists/oss-security/2022/09/23/2
      name = "CVE-2022-41318.patch";
      url = "http://www.squid-cache.org/Versions/v5/changesets/SQUID-2022_2.patch";
      hash = "sha256-wWXNTTk6K6MMn1+sdHSXwGRqADM4sC1puvwAlmw/fwU=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    perl openldap db cyrus_sasl expat libxml2 openssl
  ] ++ lib.optionals stdenv.isLinux [ libcap pam systemd ];

  enableParallelBuilding = true;

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
    "--enable-htcp"
  ] ++ lib.optional (stdenv.isLinux && !stdenv.hostPlatform.isMusl)
    "--enable-linux-netfilter";

  meta = with lib; {
    description = "A caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = "http://www.squid-cache.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz raskin ];
  };
}
