{ stdenv, fetchurl, openssl, nss, nspr, kerberos, gmp, zlib, libpcap, re2
, gcc, pythonPackages, perl, perlPackages, makeWrapper
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "john-${version}";
  version = "1.8.0-jumbo-1";

  src = fetchurl {
    url = "http://www.openwall.com/john/j/${name}.tar.xz";
    sha256 = "08q92sfdvkz47rx6qjn7qv57cmlpy7i7rgddapq5384mb413vjds";
  };

  patches = [ ./gcc5.patch ];

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
  configureFlags = [ "--disable-native-macro" ];

  buildInputs = [ openssl nss nspr kerberos gmp zlib libpcap re2 gcc pythonPackages.wrapPython perl makeWrapper ];
  propagatedBuildInputs = (with pythonPackages; [ dpkt scapy lxml ]) ++ # For pcap2john.py
                          (with perlPackages; [ DigestMD4 DigestSHA1 GetoptLong # For pass_gen.pl
                                                perlldap ]); # For sha-dump.pl
                          # TODO: Get dependencies for radius2john.pl and lion2john-alt.pl

  # gcc -DAC_BUILT -Wall vncpcap2john.o memdbg.o -g    -lpcap -fopenmp -o ../run/vncpcap2john
  # gcc: error: memdbg.o: No such file or directory
  enableParallelBuilding = false;

  NIX_CFLAGS_COMPILE = [ "-DJOHN_SYSTEMWIDE=1" ];

  postInstall = ''
    mkdir -p "$out/bin" "$out/etc/john" "$out/share/john" "$out/share/doc/john"
    find -L ../run -mindepth 1 -maxdepth 1 -type f -executable \
      -exec cp -d {} "$out/bin" \;
    cp -vt "$out/etc/john" ../run/*.conf
    cp -vt "$out/share/john" ../run/*.chr ../run/password.lst
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
    maintainers = with maintainers; [ offline ];
    platforms = [ "x86_64-linux" "x86_64-darwin"];
  };
}
