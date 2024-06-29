{ lib, stdenv, fetchFromGitHub, openssl, nss, nspr, libkrb5, gmp, zlib, libpcap, re2
, gcc, python3Packages, perl, perlPackages, makeWrapper, }:

stdenv.mkDerivation rec {
  pname = "john";
  version = "rolling-2404";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = "john";
    rev = "f9fedd238b0b1d69181c1fef033b85c787e96e57";
    hash = "sha256-zvoN+8Sx6qpVg2JeRLOIH1ehfl3tFTv7r5wQZ44Qsbc=";
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

  buildInputs = [ openssl nss nspr libkrb5 gmp zlib libpcap re2 ];
  nativeBuildInputs = [ gcc python3Packages.wrapPython perl makeWrapper ];
  propagatedBuildInputs = (with python3Packages; [ dpkt scapy lxml ]) ++ # For pcap2john.py
                          (with perlPackages; [ DigestMD4 DigestSHA1 GetoptLong # For pass_gen.pl
                                                CompressRawLzma # For 7z2john.pl
                                                perlldap ]); # For sha-dump.pl
                          # TODO: Get dependencies for radius2john.pl and lion2john-alt.pl

  # gcc -DAC_BUILT -Wall vncpcap2john.o memdbg.o -g    -lpcap -fopenmp -o ../run/vncpcap2john
  # gcc: error: memdbg.o: No such file or directory
  enableParallelBuilding = false;

  postInstall = ''
    mkdir -p "$out/bin" "$out/etc/john" "$out/share/john" "$out/share/doc/john" "$out/share/john/rules" "$out/${perlPackages.perl.libPrefix}"
    find -L ../run -mindepth 1 -maxdepth 1 -type f -executable \
      -exec cp -d {} "$out/bin" \;
    cp -vt "$out/etc/john" ../run/*.conf
    cp -vt "$out/share/john" ../run/*.chr ../run/password.lst
    cp -vt "$out/share/john/rules" ../run/rules/*.rule
    cp -vrt "$out/share/doc/john" ../doc/*
    cp -vt "$out/${perlPackages.perl.libPrefix}" ../run/lib/*
  '';

  postFixup = ''
    wrapPythonPrograms

    for i in $out/bin/*.pl; do
      wrapProgram "$i" --prefix PERL5LIB : "$PERL5LIB:$out/${perlPackages.perl.libPrefix}"
    done
  '';

  meta = with lib; {
    description = "John the Ripper password cracker";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/openwall/john/";
    maintainers = with maintainers; [ offline matthewbauer cherrykitten ];
    platforms = platforms.unix;
  };
}
