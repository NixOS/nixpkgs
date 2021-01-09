{ config, stdenv, lib, fetchurl, fetchpatch
, perl, pkg-config
, libcap, libtool, libxml2, openssl, libuv
, enablePython ? config.bind.enablePython or false, python3 ? null
, enableSeccomp ? false, libseccomp ? null, buildPackages, nixosTests
}:

assert enableSeccomp -> libseccomp != null;
assert enablePython -> python3 != null;

stdenv.mkDerivation rec {
  pname = "bind";
  version = "9.16.10";

  src = fetchurl {
    url = "https://downloads.isc.org/isc/bind9/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-vEf8AZxiBeamv7g5xUShRyMh3wU3upBbhGpMv/4zYrM=";
  };

  outputs = [ "out" "lib" "dev" "man" "dnsutils" "host" ];

  patches = [
    ./dont-keep-configure-flags.patch
    ./remove-mkdir-var.patch
  ];

  nativeBuildInputs = [ perl pkg-config ];
  buildInputs = [ libtool libxml2 openssl libuv ]
    ++ lib.optional stdenv.isLinux libcap
    ++ lib.optional enableSeccomp libseccomp
    ++ lib.optional enablePython (python3.withPackages (ps: with ps; [ ply ]));

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-libtool"
    (if enablePython then "--with-python" else "--without-python")
    "--without-atf"
    "--without-dlopen"
    "--without-docbook-xsl"
    "--without-gssapi"
    "--without-idn"
    "--without-idnlib"
    "--without-lmdb"
    "--without-libjson"
    "--without-pkcs11"
    "--without-purify"
    "--with-randomdev=/dev/random"
    "--with-ecdsa"
    "--with-gost"
    "--without-eddsa"
    "--with-aes"
  ] ++ lib.optional stdenv.isLinux "--with-libcap=${libcap.dev}"
    ++ lib.optional enableSeccomp "--enable-seccomp"
    ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "BUILD_CC=$(CC_FOR_BUILD)";

  postInstall = ''
    moveToOutput bin/bind9-config $dev

    moveToOutput bin/host $host

    moveToOutput bin/dig $dnsutils
    moveToOutput bin/delv $dnsutils
    moveToOutput bin/nslookup $dnsutils
    moveToOutput bin/nsupdate $dnsutils

    for f in "$lib/lib/"*.la "$dev/bin/"bind*-config; do
      sed -i "$f" -e 's|-L${openssl.dev}|-L${openssl.out}|g'
    done
  '';

  doCheck = false; # requires root and the net

  passthru.tests = { inherit (nixosTests) bind; };

  meta = with stdenv.lib; {
    homepage = "https://www.isc.org/downloads/bind/";
    description = "Domain name server";
    license = licenses.mpl20;

    maintainers = with maintainers; [ peti globin ];
    platforms = platforms.unix;

    outputsToInstall = [ "out" "dnsutils" "host" ];
  };
}
