{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook, removeReferencesTo
, file, openssl, perl, perlPackages, unzip, nettools, ncurses }:

stdenv.mkDerivation rec {
  pname = "net-snmp";
  version = "5.9";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${pname}-${version}.tar.gz";
    sha256 = "0wb0vyafpspw3mcifkjjmf17r1r80kjvslycscb8nvaxz1k3lc04";
  };

  patches =
    let fetchAlpinePatch = name: sha256: fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/net-snmp/${name}?id=f25d3fb08341b60b6ccef424399f060dfcf3f1a5";
      inherit name sha256;
    };
  in [
    (fetchAlpinePatch "fix-includes.patch" "0zpkbb6k366qpq4dax5wknwprhwnhighcp402mlm7950d39zfa3m")
    (fetchAlpinePatch "netsnmp-swinst-crash.patch" "0gh164wy6zfiwiszh58fsvr25k0ns14r3099664qykgpmickkqid")
  ];

  outputs = [ "bin" "out" "dev" "lib" ];

  configureFlags =
    [ "--with-default-snmp-version=3"
      "--with-sys-location=Unknown"
      "--with-sys-contact=root@unknown"
      "--with-logfile=/var/log/net-snmpd.log"
      "--with-persistent-directory=/var/lib/net-snmp"
      "--with-openssl=${openssl.dev}"
      "--disable-embedded-perl"
      "--without-perl-modules"
    ] ++ lib.optional stdenv.isLinux "--with-mnttab=/proc/mounts";

  postPatch = ''
    substituteInPlace testing/fulltests/support/simple_TESTCONF.sh --replace "/bin/netstat" "${nettools}/bin/netstat"
  '';

  nativeBuildInputs = [ autoreconfHook nettools removeReferencesTo unzip ];
  buildInputs = with perlPackages; [ file perl openssl ncurses JSON Tk TermReadKey ];

  enableParallelBuilding = true;
  doCheck = false;  # tries to use networking

  postInstall = ''
    for f in "$lib/lib/"*.la $bin/bin/net-snmp-config $bin/bin/net-snmp-create-v3-user; do
      sed 's|-L${openssl.dev}|-L${openssl.out}|g' -i $f
    done
    mkdir $dev/bin
    mv $bin/bin/net-snmp-config $dev/bin
    # libraries contain configure options
    find $lib/lib -type f -exec remove-references-to -t $bin '{}' +
    find $lib/lib -type f -exec remove-references-to -t $dev '{}' +
  '';

  meta = with lib; {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = "http://net-snmp.sourceforge.net/";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
