{ stdenv, fetchurl, fetchpatch, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "squid";
  version = "4.10";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v4/${pname}-${version}.tar.xz";
    sha256 = "07sz0adv8nkhy797675bpra7lvdkwjq9isw1ddgylhlazl511w4q";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-11945.patch";
      url = "http://www.squid-cache.org/Versions/v4/changesets/squid-4-eeebf0f37a72a2de08348e85ae34b02c34e9a811.patch";
      sha256 = "1mdi1camvaa6pmpiypw4zmmc4a4mgqgcvdic5wajysgwsqvbz1f3";
    })
  ];

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
