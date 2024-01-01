{ lib, stdenv, fetchurl, perl, openldap, pam, db, cyrus_sasl, libcap
, expat, libxml2, openssl, pkg-config, systemd
, cppunit
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "squid";
  version = "5.9";

  src = fetchurl {
    url = "http://www.squid-cache.org/Versions/v5/${pname}-${version}.tar.xz";
    hash = "sha256-P+XCAH2idXRGr5G275dPFUsggSCpo5OW6mgeXEq7BLU=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-46847.patch";
      url = "http://www.squid-cache.org/Versions/v5/SQUID-2023_3.patch";
      hash = "sha256-ofY9snWOsfHTCZcK7HbsLD0j5nP+O0eitWU4fK/mSqA=";
    })
    (fetchpatch {
      name = "CVE-2023-50269.patch";
      url = "http://www.squid-cache.org/Versions/v5/SQUID-2023_10.patch";
      hash = "sha256-xa81wd2WAUboUhMpDcsj33sKoIzPF00tZDY/pw76XYQ=";
    })
    (fetchpatch {
      name = "CVE-2023-49285.patch";
      url = "http://www.squid-cache.org/Versions/v5/SQUID-2023_7.patch";
      hash = "sha256-G6DZhHCfzoIb+q+sw0a5cMF6rSvrLhT7ntp0KiiCVSA=";
    })
    (fetchpatch {
      name = "CVE-2023-46848.patch";
      url = "http://www.squid-cache.org/Versions/v5/SQUID-2023_5.patch";
      hash = "sha256-aduHoEqU/XKuh57y7tUDr7zIRprfC24Ifw5Ep0aboCg=";
    })
    (fetchpatch {
      name = "CVE-2023-46724.patch";
      url = "http://www.squid-cache.org/Versions/v5/SQUID-2023_4.patch";
      hash = "sha256-Ptt/yweUmB3lfg/o3mdBIjzpntCkRR9wDruQNYJifmE=";
    })
    (fetchpatch {
      name = "CVE-2023-46846.patch";
      url = "http://www.squid-cache.org/Versions/v5/SQUID-2023_1.patch";
      hash = "sha256-Tu8oJTlYleKlZPfD3rslNfkLVcB8sjp25+N/9S423+8=";
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

  doCheck = true;
  nativeCheckInputs = [ cppunit ];
  preCheck = ''
    # tests attempt to copy around "/bin/true" to make some things
    # no-ops but this doesn't work if our "true" is a multi-call
    # binary, so make our own fake "true" which will work when used
    # this way
    echo "#!$SHELL" > fake-true
    chmod +x fake-true
    grep -rlF '/bin/true' test-suite/ | while read -r filename ; do
      substituteInPlace "$filename" \
        --replace "$(type -P true)" "$(realpath fake-true)" \
        --replace "/bin/true" "$(realpath fake-true)"
    done
  '';

  meta = with lib; {
    description = "A caching proxy for the Web supporting HTTP, HTTPS, FTP, and more";
    homepage = "http://www.squid-cache.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ raskin ];
    knownVulnerabilities = [
      "GHSA-rj5h-46j6-q2g5"
      "CVE-2023-5824"
      "CVE-2023-46728"
      "CVE-2023-49286"
      "Several outstanding, unnumbered issues from https://megamansec.github.io/Squid-Security-Audit/ with unclear status"
    ];
  };
}
