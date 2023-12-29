{ lib, stdenv, fetchurl, fetchpatch, removeReferencesTo
, file, openssl, perl, perlPackages, nettools
, withPerlTools ? false }: let

  perlWithPkgs = perl.withPackages (ps: with ps; [
    JSON
    TermReadKey
    Tk
  ]);

in stdenv.mkDerivation rec {
  pname = "net-snmp";
  version = "5.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${pname}-${version}.tar.gz";
    sha256 = "sha256-i03gE5HnTjxwFL60OWGi1tb6A6zDQoC5WF9JMHRbBUQ=";
  };

  patches =
    let fetchAlpinePatch = name: sha256: fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/main/net-snmp/${name}?id=ebb21045c31f4d5993238bcdb654f21d8faf8123";
      inherit name sha256;
    };
  in [
    (fetchAlpinePatch "fix-includes.patch" "0zpkbb6k366qpq4dax5wknwprhwnhighcp402mlm7950d39zfa3m")
    (fetchAlpinePatch "netsnmp-swinst-crash.patch" "0gh164wy6zfiwiszh58fsvr25k0ns14r3099664qykgpmickkqid")
    (fetchAlpinePatch "fix-fd_mask.patch" "/i9ve61HjDzqZt+u1wajNtSQoizl+KePvhcAt24HKd0=")
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

  nativeBuildInputs = [ nettools removeReferencesTo file ];
  buildInputs = [ openssl ]
    ++ lib.optional withPerlTools perlWithPkgs;

  enableParallelBuilding = true;
  # Missing dependencies during relinking:
  #   ./.libs/libnetsnmpagent.so: file not recognized: file format not recognized
  enableParallelInstalling = false;
  doCheck = false;  # tries to use networking

  postInstall = ''
    for f in "$lib/lib/"*.la $bin/bin/net-snmp-config $bin/bin/net-snmp-create-v3-user; do
      sed 's|-L${openssl.dev}|-L${lib.getLib openssl}|g' -i $f
    done
    mkdir $dev/bin
    mv $bin/bin/net-snmp-config $dev/bin
    # libraries contain configure options
    find $lib/lib -type f -exec remove-references-to -t $bin '{}' +
    find $lib/lib -type f -exec remove-references-to -t $dev '{}' +
  '';

  meta = with lib; {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = "http://www.net-snmp.org/";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
