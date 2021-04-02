{ config, stdenv, lib, fetchurl, fetchpatch
, perl
, libcap, libtool, libxml2, openssl
, enablePython ? config.bind.enablePython or false, python3 ? null
, enableSeccomp ? false, libseccomp ? null, buildPackages
}:

assert enableSeccomp -> libseccomp != null;
assert enablePython -> python3 != null;

stdenv.mkDerivation rec {
  pname = "bind";
  version = "9.14.12";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/bind9/${version}/${pname}-${version}.tar.gz";
    sha256 = "1j7ldvdschmvzxrbajjhmdsl2iqxc1lm64vk0a5sdykxpy9y8kcw";
  };

  outputs = [ "out" "lib" "dev" "man" "dnsutils" "host" ];

  patches = [
    ./dont-keep-configure-flags.patch
    ./remove-mkdir-var.patch
    (fetchpatch {
      name = "CVE-2020-8621.patch";
      url = "https://gitlab.isc.org/isc-projects/bind9/commit/81514ff925dfc6e0c293745e0fc8320a8af95586.patch";
      sha256 = "1h3p60xcxj1zd3ksqllhgr4z43li13n2famyvb8kyydycw0rhi4d";
    })
    (fetchpatch {
      name = "CVE-2020-8622.patch";
      url = "https://gitlab.isc.org/isc-projects/bind9/commit/6ed167ad0a647dff20c8cb08c944a7967df2d415.patch";
      sha256 = "1r191hvqabq8bpnik8hmx7qirghfv48fhrzzmiq8vbjmwkbvvjrj";
    })
    (fetchpatch {
      name = "CVE-2020-8624.patch";
      url = "https://gitlab.isc.org/isc-projects/bind9/commit/7630a64141a997b5247d9ad4a7dfff6ac6d9a485.patch";
      sha256 = "01xbi0nrl9zqv8yih92x2xman23dr8lbkxy4frrzsikfak41s1zd";
    })
    (fetchpatch {
      name = "CVE-2020-8625.patch";
      url = "https://gitlab.isc.org/isc-projects/bind9/commit/b04cb88462863d762093760ffcfe1946200e30f5.patch";
      sha256 = "14h57z1jpp4hbqp8wmdwnfwgz63v8zdcy1gzgjbwg8nbfy2h1gmk";
    })
  ];

  nativeBuildInputs = [ perl ];
  buildInputs = [ libtool libxml2 openssl ]
    ++ lib.optional stdenv.isLinux libcap
    ++ lib.optional enableSeccomp libseccomp
    ++ lib.optional enablePython (python3.withPackages (ps: with ps; [ ply ]));

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-libtool"
    "--with-libxml2=${libxml2.dev}"
    "--with-openssl=${openssl.dev}"
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
    moveToOutput bin/isc-config.sh $dev

    moveToOutput bin/host $host

    moveToOutput bin/dig $dnsutils
    moveToOutput bin/delv $dnsutils
    moveToOutput bin/nslookup $dnsutils
    moveToOutput bin/nsupdate $dnsutils

    for f in "$lib/lib/"*.la "$dev/bin/"{isc-config.sh,bind*-config}; do
      sed -i "$f" -e 's|-L${openssl.dev}|-L${openssl.out}|g'
    done
  '';

  doCheck = false; # requires root and the net

  meta = with stdenv.lib; {
    homepage = "https://www.isc.org/downloads/bind/";
    description = "Domain name server";
    license = licenses.mpl20;

    maintainers = with maintainers; [ peti globin ];
    platforms = platforms.unix;

    outputsToInstall = [ "out" "dnsutils" "host" ];
  };
}
