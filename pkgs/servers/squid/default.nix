{ stdenv, fetchurl, fetchpatch, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl }:

stdenv.mkDerivation rec {
  name = "squid-3.5.27";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v3/3.5/${name}.tar.xz";
    sha256 = "1v7hzvwwghrs751iag90z8909nvyp3c5jynaz4hmjqywy9kl7nsx";
  };

  buildInputs = [
    perl openldap pam db cyrus_sasl libcap expat libxml2 openssl
  ];

  patches = [
    (fetchpatch {
      name = "CVE-2018-1000024.patch";
      url = http://www.squid-cache.org/Versions/v3/3.5/changesets/SQUID-2018_1.patch;
      sha256 = "0vzxr4rmybz0w4c1hi3szvqawbzl4r4b8wyvq9vgq1mzkk5invpg";
    })
    (fetchpatch {
      name = "CVE-2018-1000027.patch";
      url = http://www.squid-cache.org/Versions/v3/3.5/changesets/SQUID-2018_2.patch;
      sha256 = "1a8hwk9z7h1j0c57anfzp3bwjd4pjbyh8aks4ca79nwz4d0y6wf3";
    })
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
    homepage = http://www.squid-cache.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
