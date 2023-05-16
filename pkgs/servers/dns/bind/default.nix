<<<<<<< HEAD
{ stdenv
, lib
, fetchurl
, perl
, pkg-config
, libcap
, libidn2
, libtool
, libxml2
, openssl
, libuv
, nghttp2
, jemalloc
, enablePython ? false
, python3
, enableGSSAPI ? true
, libkrb5
, buildPackages
, nixosTests
, cmocka
, tzdata
, gitUpdater
=======
{ config, stdenv, lib, fetchurl, fetchpatch
, perl, pkg-config
, libcap, libtool, libxml2, openssl, libuv, nghttp2, jemalloc
, enablePython ? false, python3
, enableGSSAPI ? true, libkrb5
, buildPackages, nixosTests
, cmocka, tzdata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "bind";
<<<<<<< HEAD
  version = "9.18.18";

  src = fetchurl {
    url = "https://downloads.isc.org/isc/bind9/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-1zXNwSemxXCb3kdbW/FvohM/Nv26IC98PDfRNOUZIWA=";
=======
  version = "9.18.14";

  src = fetchurl {
    url = "https://downloads.isc.org/isc/bind9/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-muEu32rDxDCzPs0afAwMYIddJVGF64eFD6ml55SmSgk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "lib" "dev" "man" "dnsutils" "host" ];

  patches = [
    ./dont-keep-configure-flags.patch
  ];

  nativeBuildInputs = [ perl pkg-config ];
<<<<<<< HEAD
  buildInputs = [ libidn2 libtool libxml2 openssl libuv nghttp2 jemalloc ]
=======
  buildInputs = [ libtool libxml2 openssl libuv nghttp2 jemalloc ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ lib.optional stdenv.isLinux libcap
    ++ lib.optional enableGSSAPI libkrb5
    ++ lib.optional enablePython (python3.withPackages (ps: with ps; [ ply ]));

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [
    "--localstatedir=/var"
    "--without-lmdb"
<<<<<<< HEAD
    "--with-libidn2"
  ] ++ lib.optional enableGSSAPI "--with-gssapi=${libkrb5.dev}/bin/krb5-config"
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "BUILD_CC=$(CC_FOR_BUILD)";
=======
  ] ++ lib.optional enableGSSAPI "--with-gssapi=${libkrb5.dev}/bin/krb5-config"
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "BUILD_CC=$(CC_FOR_BUILD)";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

    cat <<EOF >$out/etc/rndc.conf
    include "/etc/bind/rndc.key";
    options {
        default-key "rndc-key";
        default-server 127.0.0.1;
        default-port 953;
    };
    EOF
  '';

  enableParallelBuilding = true;
  # TODO: investigate the aarch64-linux failures; see this and linked discussions:
  # https://github.com/NixOS/nixpkgs/pull/192962
<<<<<<< HEAD
  doCheck = with stdenv.hostPlatform; !isStatic && !(isAarch64 && isLinux)
    # https://gitlab.isc.org/isc-projects/bind9/-/issues/4269
    && !is32bit;
=======
  doCheck = with stdenv.hostPlatform; !isStatic && !(isAarch64 && isLinux);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkTarget = "unit";
  checkInputs = [
    cmocka
  ] ++ lib.optionals (!stdenv.hostPlatform.isMusl) [
    tzdata
  ];
  preCheck = lib.optionalString stdenv.hostPlatform.isMusl ''
    # musl doesn't respect TZDIR, skip timezone-related tests
    sed -i '/^ISC_TEST_ENTRY(isc_time_formatISO8601L/d' tests/isc/time_test.c
  '';

<<<<<<< HEAD
  passthru = {
    tests = {
      inherit (nixosTests) bind;
      prometheus-exporter = nixosTests.prometheus-exporters.bind;
      kubernetes-dns-single-node = nixosTests.kubernetes.dns-single-node;
      kubernetes-dns-multi-node = nixosTests.kubernetes.dns-multi-node;
    };

    updateScript = gitUpdater {
      # No nicer place to find latest stable release.
      url = "https://gitlab.isc.org/isc-projects/bind9.git";
      rev-prefix = "v";
      # Avoid unstable 9.19 releases.
      odd-unstable = true;
    };
=======
  passthru.tests = {
    inherit (nixosTests) bind;
    prometheus-exporter = nixosTests.prometheus-exporters.bind;
    kubernetes-dns-single-node = nixosTests.kubernetes.dns-single-node;
    kubernetes-dns-multi-node = nixosTests.kubernetes.dns-multi-node;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
