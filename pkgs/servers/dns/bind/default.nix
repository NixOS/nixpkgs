{ config, stdenv, lib, fetchurl
, perl
, libcap, libtool, libxml2, openssl
, enablePython ? config.bind.enablePython or false, python3 ? null
, enableSeccomp ? false, libseccomp ? null, buildPackages
}:

assert enableSeccomp -> libseccomp != null;
assert enablePython -> python3 != null;

let version = "9.12.3-P1"; in

stdenv.mkDerivation rec {
  name = "bind-${version}";

  src = fetchurl {
    url = "https://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "0wzdbn6ig851354cjdys5q3gvqcvl2gmmih1gzr8ldl7sy4r7dvc";
  };

  outputs = [ "out" "lib" "dev" "man" "dnsutils" "host" ];

  patches = [ ./dont-keep-configure-flags.patch ./remove-mkdir-var.patch ] ++
    stdenv.lib.optional stdenv.isDarwin ./darwin-openssl-linking-fix.patch;

  nativeBuildInputs = [ perl ];
  buildInputs = [ libtool libxml2 openssl ]
    ++ lib.optional stdenv.isLinux libcap
    ++ lib.optional enableSeccomp libseccomp
    ++ lib.optional enablePython (python3.withPackages (ps: with ps; [ ply ]));

  STD_CDEFINES = [ "-DDIG_SIGCHASE=1" ]; # support +sigchase

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
    ++ lib.optional enableSeccomp "--enable-seccomp";

  postInstall = ''
    moveToOutput bin/bind9-config $dev
    moveToOutput bin/isc-config.sh $dev

    moveToOutput bin/host $host

    moveToOutput bin/dig $dnsutils
    moveToOutput bin/nslookup $dnsutils
    moveToOutput bin/nsupdate $dnsutils

    for f in "$lib/lib/"*.la "$dev/bin/"{isc-config.sh,bind*-config}; do
      sed -i "$f" -e 's|-L${openssl.dev}|-L${openssl.out}|g'
    done
  '';

  doCheck = false; # requires root and the net

  meta = {
    homepage = http://www.isc.org/software/bind;
    description = "Domain name server";
    license = stdenv.lib.licenses.mpl20;

    maintainers = with stdenv.lib.maintainers; [peti];
    platforms = with stdenv.lib.platforms; unix;

    outputsToInstall = [ "out" "dnsutils" "host" ];
  };
}
