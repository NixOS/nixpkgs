{ stdenv, fetchurl, fetchpatch, autoreconfHook, file, openssl, perl, perlPackages, unzip, nettools, ncurses }:

stdenv.mkDerivation rec {
  name = "net-snmp-5.8";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${name}.tar.gz";
    sha256 = "1pvajzj9gmj56dmwix0ywmkmy2pglh6nny646hkm7ghfhh03bz5j";
  };

  patches =
    let fetchAlpinePatch = name: sha256: fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/net-snmp/${name}?id=f25d3fb08341b60b6ccef424399f060dfcf3f1a5";
      inherit name sha256;
    };
  in [
    (fetchAlpinePatch "fix-includes.patch" "0zpkbb6k366qpq4dax5wknwprhwnhighcp402mlm7950d39zfa3m")
    (fetchAlpinePatch "netsnmp-swinst-crash.patch" "0gh164wy6zfiwiszh58fsvr25k0ns14r3099664qykgpmickkqid")
    ./0002-autoconf-version.patch
  ];

  configureFlags =
    [ "--with-default-snmp-version=3"
      "--with-sys-location=Unknown"
      "--with-sys-contact=root@unknown"
      "--with-logfile=/var/log/net-snmpd.log"
      "--with-persistent-directory=/var/lib/net-snmp"
      "--with-openssl=${openssl.dev}"
      "--disable-embedded-perl"
      "--without-perl-modules"
    ] ++ stdenv.lib.optional stdenv.isLinux "--with-mnttab=/proc/mounts";

  postPatch = ''
    substituteInPlace testing/fulltests/support/simple_TESTCONF.sh --replace "/bin/netstat" "${nettools}/bin/netstat"
  '';

  nativeBuildInputs = [ autoreconfHook nettools ];
  buildInputs = [ file perl unzip openssl ncurses ];
  propagatedBuildInputs = with perlPackages; [ perl JSON Tk TermReadKey ];

  enableParallelBuilding = true;
  doCheck = false;  # tries to use networking

  postInstall = ''
    for f in "$out/lib/"*.la $out/bin/net-snmp-config $out/bin/net-snmp-create-v3-user; do
      sed 's|-L${openssl.dev}|-L${openssl.out}|g' -i $f
    done
  '';

  meta = with stdenv.lib; {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = http://net-snmp.sourceforge.net/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
