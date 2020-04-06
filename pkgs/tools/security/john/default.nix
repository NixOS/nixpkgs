{ stdenv, fetchurl, openssl, nss, nspr, kerberos, gmp, zlib, libpcap, re2
, gcc, python3Packages, perl, perlPackages, makeWrapper
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "john";
  version = "1.9.0-jumbo-1";

  src = fetchurl {
    url = "http://www.openwall.com/john/k/${pname}-${version}.tar.xz";
    sha256 = "0fvz3v41hnaiv1ggpxanfykyfjq79cwp9qcqqn63vic357w27lgm";
  };

  postPatch = ''
    sed -ri -e '
      s!^(#define\s+CFG_[A-Z]+_NAME\s+).*/!\1"'"$out"'/etc/john/!
      /^#define\s+JOHN_SYSTEMWIDE/s!/usr!'"$out"'!
    ' src/params.h
    sed -ri -e '/^\.include/ {
      s!\$JOHN!'"$out"'/etc/john!
      s!^(\.include\s*)<([^./]+\.conf)>!\1"'"$out"'/etc/john/\2"!
    }' run/*.conf
  '';

  preConfigure = ''
    cd src
    # Makefile.in depends on AS and LD being set to CC, which is set by default in configure.ac.
    # This ensures we override the environment variables set in cc-wrapper/setup-hook.sh
    export AS=$CC
    export LD=$CC
  '';
  configureFlags = [
    "--disable-native-tests"
    "--with-systemwide"
  ];

  buildInputs = [ openssl nss nspr kerberos gmp zlib libpcap re2 ];
  nativeBuildInputs = [ gcc python3Packages.wrapPython perl makeWrapper ];
  propagatedBuildInputs = (with python3Packages; [ dpkt scapy lxml ]) ++ # For pcap2john.py
                          (with perlPackages; [ DigestMD4 DigestSHA1 GetoptLong # For pass_gen.pl
                                                perlldap ]); # For sha-dump.pl
                          # TODO: Get dependencies for radius2john.pl and lion2john-alt.pl

  # gcc -DAC_BUILT -Wall vncpcap2john.o memdbg.o -g    -lpcap -fopenmp -o ../run/vncpcap2john
  # gcc: error: memdbg.o: No such file or directory
  enableParallelBuilding = false;

  postInstall = ''
    mkdir -p "$out/bin" "$out/etc/john" "$out/share/john" "$out/share/doc/john" "$out/share/john/rules"
    find -L ../run -mindepth 1 -maxdepth 1 -type f -executable \
      -exec cp -d {} "$out/bin" \;
    cp -vt "$out/etc/john" ../run/*.conf
    cp -vt "$out/share/john" ../run/*.chr ../run/password.lst
    cp -vt "$out/share/john/rules" ../run/rules/*.rule
    cp -vrt "$out/share/doc/john" ../doc/*
  '';

  postFixup = ''
    wrapPythonPrograms

    for i in $out/bin/*.pl; do
      wrapProgram "$i" --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = {
    description = "John the Ripper password cracker";
    license = licenses.gpl2;
    homepage = https://github.com/magnumripper/JohnTheRipper/;
    maintainers = with maintainers; [ offline matthewbauer ];
    platforms = platforms.unix;
  };
}
