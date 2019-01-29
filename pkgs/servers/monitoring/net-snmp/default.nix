{ stdenv, fetchurl, fetchpatch, autoreconfHook, file, openssl, perl, unzip }:

stdenv.mkDerivation rec {
  name = "net-snmp-5.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${name}.zip";
    sha256 = "0gkss3zclm23zwpqfhddca8278id7pk6qx1mydpimdrrcndwgpz8";
  };

  patches =
    let fetchAlpinePatch = name: sha256: fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/net-snmp/${name}?id=f25d3fb08341b60b6ccef424399f060dfcf3f1a5";
      inherit name sha256;
    };
  in [
    (fetchAlpinePatch "CVE-2015-5621.patch" "05098jyvd9ddr5q26z7scbbvk1bk6x4agpjm6pyprvpc1zpi0y09")
    (fetchAlpinePatch "fix-Makefile-PL.patch" "14ilnkj3cr6mpi242hrmmmv8nv4dj0fdgn42qfk9aa7scwsc0lc7")
    (fetchAlpinePatch "fix-includes.patch" "0zpkbb6k366qpq4dax5wknwprhwnhighcp402mlm7950d39zfa3m")
    (fetchAlpinePatch "netsnmp-swinst-crash.patch" "0gh164wy6zfiwiszh58fsvr25k0ns14r3099664qykgpmickkqid")
    (fetchAlpinePatch "remove-U64-typedef.patch" "1msxyhcqkvhqa03dwb50288g7f6nbrcd9cs036m9xc8jdgjb8k8j")
    ./CVE-2018-18065.patch
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
    ] ++ stdenv.lib.optional stdenv.isLinux "--with-mnttab=/proc/mounts";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ file perl unzip openssl ];

  enableParallelBuilding = true;
  doCheck = false; # fails

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
