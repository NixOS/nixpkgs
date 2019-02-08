{ stdenv, lib, fetchurl, fetchpatch, darwin, autoreconfHook
, file, openssl, perl, unzip, ncurses }:

stdenv.mkDerivation rec {
  name = "net-snmp-${version}";
  version = "5.8";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${name}.zip";
    sha256 = "0hk0lmvr8jhiza8f7hl2n3kpwzmgbl09fhgyj1cg117dp22i6af6";
  };

  patches =
    let fetchAlpinePatch = name: sha256: fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/net-snmp/${name}?id=f25d3fb08341b60b6ccef424399f060dfcf3f1a5";
      inherit name sha256;
    };
  in [
    (fetchAlpinePatch "fix-includes.patch" "0zpkbb6k366qpq4dax5wknwprhwnhighcp402mlm7950d39zfa3m")
    (fetchAlpinePatch "netsnmp-swinst-crash.patch" "0gh164wy6zfiwiszh58fsvr25k0ns14r3099664qykgpmickkqid")
  ];

  preConfigure =
    ''
      perlarchname=$(perl -e 'use Config; print $Config{archname};')
      installFlags="INSTALLSITEARCH=$out/${perl.libPrefix}/${perl.version}/$perlarchname INSTALLSITEMAN3DIR=$out/share/man/man3"

      # http://article.gmane.org/gmane.network.net-snmp.user/32434
      substituteInPlace "man/Makefile.in" --replace 'grep -vE' '@EGREP@ -v'
    '';

  configureFlags =
    [ "--with-default-snmp-version=3"
      "--with-sys-location=Unknown"
      "--with-sys-contact=root@unknown"
      "--with-logfile=/var/log/net-snmpd.log"
      "--with-persistent-directory=/var/lib/net-snmp"
      "--with-openssl=${openssl.dev}"
    ] ++ lib.optional stdenv.isLinux "--with-mnttab=/proc/mounts";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ file perl unzip openssl ncurses ] ++
    lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;
      [ DiskArbitration IOKit ApplicationServices ]);

  enableParallelBuilding = true;

  postInstall = ''
    for f in "$out/lib/"*.la $out/bin/net-snmp-config $out/bin/net-snmp-create-v3-user; do
      sed 's|-L${openssl.dev}|-L${openssl.out}|g' -i $f
    done
  '';

  meta = with lib; {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = http://net-snmp.sourceforge.net/;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
