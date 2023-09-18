# Build steps adapted from https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/tcc-0.9.27/tcc-musl-pass1.sh
#
# SPDX-FileCopyrightText: 2021-22 fosslinux <fosslinux@aussies.space>
#
# SPDX-License-Identifier: GPL-3.0-or-later

{ lib
, fetchurl
, callPackage
, bash
, tinycc-bootstrappable
, musl
, gnupatch
, gnutar
, bzip2
}:
let
  pname = "tinycc-musl";
  version = "0.9.27";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/tinycc/tcc-${version}.tar.bz2";
    hash = "sha256-3iOvePypDOMt/y3UWzQysjNHQLubt7Bb9g/b/Dls65w=";
  };

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/424aa5be38a3023aa6842883a3954599b1597986/sysa/tcc-0.9.27/tcc-musl-pass1.sh
  liveBootstrap = "https://github.com/fosslinux/live-bootstrap/raw/424aa5be38a3023aa6842883a3954599b1597986/sysa/tcc-0.9.27";
  patches = [
    (fetchurl {
      url = "${liveBootstrap}/patches/ignore-duplicate-symbols.patch";
      hash = "sha256-6Js8HkzjYlA8ETxeEYRWu+03OJI60NvR5h1QPkcMTlQ=";
    })
    (fetchurl {
      url = "${liveBootstrap}/patches/ignore-static-inside-array.patch";
      hash = "sha256-IF4RevLGjzRBuYqhuyG7+x6SVljzMAsYRKicNsmtbDY=";
    })
    (fetchurl {
      url = "${liveBootstrap}/patches/static-link.patch";
      hash = "sha256-gX/hJ9a/0Zg29KIBUme+mOA8WrPQvp0SvojP8DN9mSI=";
    })
  ];

  meta = with lib; {
      description = "Small, fast, and embeddable C compiler and interpreter";
      homepage = "http://savannah.nongnu.org/projects/tinycc";
      license = licenses.lgpl21Only;
      maintainers = teams.minimal-bootstrap.members;
      platforms = [ "i686-linux" ];
    };

  tinycc-musl = bash.runCommand "${pname}-${version}" {
    inherit pname version meta;

    nativeBuildInputs = [
      tinycc-bootstrappable.compiler
      gnupatch
      gnutar
      bzip2
    ];
  } ''
    # Unpack
    cp ${src} tinycc.tar.bz2
    bunzip2 tinycc.tar.bz2
    tar xf tinycc.tar
    rm tinycc.tar
    cd tcc-${version}

    # Patch
    ${lib.concatMapStringsSep "\n" (f: "patch -Np0 -i ${f}") patches}

    # Configure
    touch config.h

    # Build
    # We first have to recompile using tcc-0.9.26 as tcc-0.9.27 is not self-hosting,
    # but when linked with musl it is.
    ln -s ${musl}/lib/libtcc1.a ./libtcc1.a

    tcc -v \
      -static \
      -o tcc-musl \
      -D TCC_TARGET_I386=1 \
      -D CONFIG_TCCDIR=\"\" \
      -D CONFIG_TCC_CRTPREFIX=\"{B}\" \
      -D CONFIG_TCC_ELFINTERP=\"/musl/loader\" \
      -D CONFIG_TCC_LIBPATHS=\"{B}\" \
      -D CONFIG_TCC_SYSINCLUDEPATHS=\"${musl}/include\" \
      -D TCC_LIBGCC=\"libc.a\" \
      -D TCC_LIBTCC1=\"libtcc1.a\" \
      -D CONFIG_TCC_STATIC=1 \
      -D CONFIG_USE_LIBGCC=1 \
      -D TCC_VERSION=\"0.9.27\" \
      -D ONE_SOURCE=1 \
      -B . \
      -B ${tinycc-bootstrappable.libs}/lib \
      tcc.c
    # libtcc1.a
    rm -f libtcc1.a
    tcc -c -D HAVE_CONFIG_H=1 lib/libtcc1.c
    tcc -ar cr libtcc1.a libtcc1.o

    # Rebuild tcc-musl with itself
    ./tcc-musl \
      -v \
      -static \
      -o tcc-musl \
      -D TCC_TARGET_I386=1 \
      -D CONFIG_TCCDIR=\"\" \
      -D CONFIG_TCC_CRTPREFIX=\"{B}\" \
      -D CONFIG_TCC_ELFINTERP=\"/musl/loader\" \
      -D CONFIG_TCC_LIBPATHS=\"{B}\" \
      -D CONFIG_TCC_SYSINCLUDEPATHS=\"${musl}/include\" \
      -D TCC_LIBGCC=\"libc.a\" \
      -D TCC_LIBTCC1=\"libtcc1.a\" \
      -D CONFIG_TCC_STATIC=1 \
      -D CONFIG_USE_LIBGCC=1 \
      -D TCC_VERSION=\"0.9.27\" \
      -D ONE_SOURCE=1 \
      -B . \
      -B ${musl}/lib \
      tcc.c
    # libtcc1.a
    rm -f libtcc1.a
    ./tcc-musl -c -D HAVE_CONFIG_H=1 lib/libtcc1.c
    ./tcc-musl -ar cr libtcc1.a libtcc1.o

    # Install
    install -D tcc-musl $out/bin/tcc
    install -Dm444 libtcc1.a $out/lib/libtcc1.a
  '';
in
{
  compiler = bash.runCommand "${pname}-${version}-compiler" {
    inherit pname version meta;
    passthru.tests.hello-world = result:
      bash.runCommand "${pname}-simple-program-${version}" {} ''
        cat <<EOF >> test.c
        #include <stdio.h>
        int main() {
          printf("Hello World!\n");
          return 0;
        }
        EOF
        ${result}/bin/tcc -v -static -B${musl}/lib -o test test.c
        ./test
        mkdir $out
      '';
    passthru.tinycc-musl = tinycc-musl;
  } "install -D ${tinycc-musl}/bin/tcc $out/bin/tcc";

  libs = bash.runCommand "${pname}-${version}-libs" {
    inherit pname version meta;
  } "install -D ${tinycc-musl}/lib/libtcc1.a $out/lib/libtcc1.a";
}
