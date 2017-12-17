{ stdenv, lib, buildPackages, fetchurl, openssl, libtool, perl, libxml2, lmdb
, enableSeccomp ? false, libseccomp ? null }:

assert enableSeccomp -> libseccomp != null;

let version = "9.12.0"; in

stdenv.mkDerivation rec {
  name = "bind-${version}";

  src = fetchurl {
    url = "http://ftp.isc.org/isc/bind9/${version}/${name}.tar.gz";
    sha256 = "10iwkghl5g50b7wc17bsb9wa0dh2gd57bjlk6ynixhywz6dhx1r9";
  };

  outputs = [ "out" "lib" "dev" "man" "dnsutils" "host" ];

  patches = [ ./dont-keep-configure-flags.patch ./remove-mkdir-var.patch ] ++
    stdenv.lib.optional stdenv.isDarwin ./darwin-openssl-linking-fix.patch;

  nativeBuildInputs = [ perl ] ++
    stdenv.lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) buildPackages.stdenv.cc;
  buildInputs = [ openssl libtool libxml2 lmdb ] ++
    stdenv.lib.optional enableSeccomp libseccomp;
    #stdenv.lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) perl;

  STD_CDEFINES = [ "-DDIG_SIGCHASE=1" ]; # support +sigchase

  configureFlags = [
    "--localstatedir=/var"
    "--with-libtool"
    "--with-libxml2=${libxml2.dev}"
    "--with-openssl=${openssl.dev}"
    "--without-atf"
    "--without-dlopen"
    "--without-docbook-xsl"
    "--without-gssapi"
    "--without-idn"
    "--without-idnlib"
    "--without-lmdb"
    "--without-pkcs11"
    "--without-purify"
    "--without-python"
    "--with-randomdev=/dev/random"
    "--with-ecdsa=yes"
    "--with-gost=yes"
    "AR=${stdenv.cc.bintools}/bin/${stdenv.cc.bintools.targetPrefix}ar"
  ] ++ lib.optional enableSeccomp "--enable-seccomp"
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # TODO: The full path shouldn't be needed here
    "BUILD_CC=${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc"
  ];
    #++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "--disable-symtable";

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

  meta = {
    homepage = http://www.isc.org/software/bind;
    description = "Domain name server";
    license = stdenv.lib.licenses.mpl20;

    maintainers = with stdenv.lib.maintainers; [viric peti];
    platforms = with stdenv.lib.platforms; unix;

    outputsToInstall = [ "out" "dnsutils" "host" ];
  };
}
