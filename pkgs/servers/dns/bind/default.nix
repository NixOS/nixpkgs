{ config, stdenv, lib, fetchurl, fetchpatch
, perl, pkg-config
, libcap, libtool, libxml2, openssl, libuv, nghttp2, jemalloc
, enablePython ? false, python3
, enableGSSAPI ? true, libkrb5
, buildPackages, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "bind";
  version = "9.18.5";

  src = fetchurl {
    url = "https://downloads.isc.org/isc/bind9/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-DO4HjXTwvcTsN0Q1Amsl3niS8mVAoYsioC73KKEdyuc=";
  };

  outputs = [ "out" "lib" "dev" "man" "dnsutils" "host" ];

  patches = [
    ./dont-keep-configure-flags.patch
  ];

  nativeBuildInputs = [ perl pkg-config ];
  buildInputs = [ libtool libxml2 openssl libuv nghttp2 jemalloc ]
    ++ lib.optional stdenv.isLinux libcap
    ++ lib.optional enableGSSAPI libkrb5
    ++ lib.optional enablePython (python3.withPackages (ps: with ps; [ ply ]));

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [
    "--localstatedir=/var"
    "--without-lmdb"
  ] ++ lib.optional enableGSSAPI "--with-gssapi=${libkrb5.dev}/bin/krb5-config"
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "BUILD_CC=$(CC_FOR_BUILD)";

  postInstall = ''
    moveToOutput bin/bind9-config $dev

    moveToOutput bin/host $host

    moveToOutput bin/dig $dnsutils
    moveToOutput bin/delv $dnsutils
    moveToOutput bin/nslookup $dnsutils
    moveToOutput bin/nsupdate $dnsutils

    for f in "$lib/lib/"*.la "$dev/bin/"bind*-config; do
      sed -i "$f" -e 's|-L${openssl.dev}|-L${lib.getLib openssl}|g'
    done
  '';

  doCheck = false; # requires root and the net

  passthru.tests = {
    inherit (nixosTests) bind;
    prometheus-exporter = nixosTests.prometheus-exporters.bind;
    kubernetes-dns-single-node = nixosTests.kubernetes.dns-single-node;
    kubernetes-dns-multi-node = nixosTests.kubernetes.dns-multi-node;
  };

  meta = with lib; {
    homepage = "https://www.isc.org/bind/";
    description = "Domain name server";
    license = licenses.mpl20;
    changelog = "https://downloads.isc.org/isc/bind9/cur/${lib.versions.majorMinor version}/CHANGES";
    maintainers = with maintainers; [ globin ];
    platforms = platforms.unix;

    outputsToInstall = [ "out" "dnsutils" "host" ];
  };
}
