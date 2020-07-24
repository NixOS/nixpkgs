{ stdenv, fetchFromGitHub, autoconf, automake, libtool, perl, flex, bison, curl,
  pam, popt, libiconv, libuuid, openssl_1_0_2, cyrus_sasl, sqlite, tdb, libxml2 }:

stdenv.mkDerivation rec {
  pname = "pbis-open";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "BeyondTrust";
    repo = pname;
    rev = version;
    sha256 = "081jm34sf488nwz5wzs55d6rxx3sv566x6p4h1yqcjaw36174m8v";
  };

  nativeBuildInputs = [
    autoconf automake libtool perl flex bison
  ];

  # curl must be placed after openssl_1_0_2, because it pulls openssl 1.1 dependency.
  buildInputs = [
    pam popt libiconv libuuid openssl_1_0_2 cyrus_sasl
    curl sqlite popt tdb libxml2 /*libglade2 for gtk*/
  ];

  postPatch = ''
    patchShebangs .
    sed -i -e 's/legacy//g' lwupgrade/MakeKitBuild # disable /opt/ symlinks
    sed -i -e 's/tdb.h//g' samba-interop/MakeKitBuild #include <tdb.h> fails but it won't affect the build
  '';
  preConfigure = ''
    mkdir release
    cd release
    if [ $CC = gcc ]; then
            NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error=format-overflow -Wno-error=address-of-packed-member"
    fi
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -isystem ${stdenv.lib.getDev libxml2}/include/libxml2 -Wno-error=array-bounds -Wno-error=pointer-sign -Wno-error=deprecated-declarations -Wno-error=unused-variable"
  '';
  configureScript = ''../configure'';
  configureFlags = [
    "CFLAGS=-O"
    "--docdir=${placeholder "prefix"}/share/doc"
    "--mandir=${placeholder "prefix"}/share/doc/man"
    "--datadir=${placeholder "prefix"}/share"
    "--lw-initdir=${placeholder "prefix"}/etc/init.d"
    "--selinux=no" # NixOS does not support SELinux
    "--build-isas=x86_64" # [lwbase] endianness (host/x86_32): [lwbase] ERROR: could not determine endianness
    "--fail-on-warn=no"
    # "--debug=yes"
  ]; # ^ See https://github.com/BeyondTrust/pbis-open/issues/124
  configureFlagsArray = [ "--lw-bundled-libs=linenoise-mob tomlc99 opensoap krb5 cyrus-sasl curl openldap ${ if libuuid == null then "libuuid" else "" }" ];
  # ^ it depends on old krb5 version 1.9 (issue #228)
  # linenoise-mod, tomlc99, opensoap is not in nixpkgs.
  # krb5 must be old one, and cyrus-sasl and openldap have dependency to newer libkrb5 that cause runtime error
  enableParallelBuilding = true;
  makeFlags = "SHELL=";
  hardeningDisable = [ "format" ]; # -Werror=format-security
  installPhase = ''
    mkdir $sys
    mv stage/{lib,var} $sys
    mv stage$out $out
  '';
  outputs = [ "out" "sys" ];

  meta = with stdenv.lib; {
    description = "BeyondTrust AD Bridge Open simplifies the process of joining non-Microsoft hosts to Active Directory domains";
    homepage = "https://github.com/BeyondTrust/pbis-open";
    license = with licenses; [ gpl2 lgpl21 ];
    platforms = [ "x86_64-linux" ];
  };
}
