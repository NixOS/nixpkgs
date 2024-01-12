{ lib, stdenv, fetchFromGitHub, openssl, nss, nspr, libkrb5, gmp, zlib, libpcap, re2
, gcc, python3Packages, perl, perlPackages, opencl-headers, ocl-icd, makeWrapper, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "john";
  version = "1.9.0-jumbo-1";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = pname;
    rev = "1.9.0-Jumbo-1";
    sha256 = "sha256-O1iPh5QTMjZ78sKvGbvSpaHFbBuVc1z49UKTbMa24Rs=";
  };

  patches = [
    (fetchpatch {
      name = "fix-gcc-11-struct-allignment-incompatibility.patch";
      url = "https://github.com/openwall/john/commit/154ee1156d62dd207aff0052b04c61796a1fde3b.patch";
      sha256 = "sha256-3rfS2tu/TF+KW2MQiR+bh4w/FVECciTooDQNTHNw31A=";
    })
    (fetchpatch {
      name = "improve-apple-clang-pseudo-intrinsics-portability.patch";
      url = "https://github.com/openwall/john/commit/c9825e688d1fb9fdd8942ceb0a6b4457b0f9f9b4.patch";
      excludes = [ "doc/*" ];
      sha256 = "sha256-hgoiz7IgR4f66fMP7bV1F8knJttY8g2Hxyk3QfkTu+g=";
    })
    (fetchpatch {
      name = "handle-systems-that-already-defined-cl_device_topology_amd.patch";
      url = "https://github.com/openwall/john/commit/e467645a13e8b64f96be1151c591274c2f525e40.patch";
      sha256 = "sha256-jkUJPt1m56ivM8rmoosvIQLJuhTo1ulQj3Yo2SKIVNw=";
    })
  ];

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

  # opencl_DES_bs_f_plug.o:/build/source/src/opencl_DES_bs.h:65: multiple definition of `opencl_DES_bs_index768';
  # opencl_DES_bs_b_plug.o:/build/source/src/opencl_DES_bs.h:65: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  buildInputs = [ openssl nss nspr libkrb5 gmp zlib libpcap re2 opencl-headers ocl-icd ];
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
    maintainers = with maintainers; [ offline matthewbauer ];
    platforms = platforms.unix;
  };
}
