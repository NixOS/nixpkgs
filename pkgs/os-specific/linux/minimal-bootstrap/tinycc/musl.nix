{
  lib,
  fetchurl,
  bash,
  tinycc,
  musl,
  gnupatch,
  gnutar,
  gzip,
  buildPlatform,
}:
let
  pname = "tinycc-musl";
  version = "unstable-2026-02-04";
  rev = "2125026688ba461af889ae20ff59f74abaaa767c";

  src = fetchurl {
    url = "https://codeberg.org/aleksi/tinycc/archive/${rev}.tar.gz";
    hash = "sha256-XcF0Bct24gj4kQuxjKDivvTel3m89YclO+q6Bg4o7uc=";
  };

  tccTarget =
    {
      i686-linux = "I386";
      x86_64-linux = "X86_64";
      aarch64-linux = "ARM64";
    }
    .${buildPlatform.system};

  patches = [
    ./static-link.patch
  ];

  meta = {
    description = "Small, fast, and embeddable C compiler and interpreter";
    homepage = "https://repo.or.cz/w/tinycc.git";
    license = lib.licenses.lgpl21Only;
    teams = [ lib.teams.minimal-bootstrap ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
  };

  tinycc-musl =
    bash.runCommand "${pname}-${version}"
      {
        inherit pname version meta;

        nativeBuildInputs = [
          tinycc.compiler
          gnupatch
          gnutar
          gzip
        ];
      }
      ''
        # Unpack
        tar xzf ${src}
        cd tinycc

        # Patch
        ${lib.concatMapStringsSep "\n" (f: "patch -Np0 -i ${f}") patches}

        # Configure
        touch config.h

        # Build
        # We first have to recompile using tcc-0.9.26 as tcc-0.9.27 is not self-hosting,
        # but when linked with musl it is.
        ln -s ${musl}/lib/libtcc1.a ./libtcc1.a

        tcc \
          -B ${tinycc.libs}/lib \
          -DC2STR \
          -o c2str \
          conftest.c
        ./c2str include/tccdefs.h tccdefs_.h

        tcc -v \
          -static \
          -o tcc-musl \
          -D TCC_TARGET_${tccTarget}=1 \
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
          -D TCC_MUSL=1 \
          -D CONFIG_TCC_PREDEFS=1 \
          -D CONFIG_TCC_SEMLOCK=0 \
          -D CONFIG_TCC_BACKTRACE=0 \
          -B . \
          -B ${tinycc.libs}/lib \
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
          -D TCC_TARGET_${tccTarget}=1 \
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
          -D TCC_MUSL=1 \
          -D CONFIG_TCC_PREDEFS=1 \
          -D CONFIG_TCC_SEMLOCK=0 \
          -D CONFIG_TCC_BACKTRACE=0 \
          -B . \
          -B ${musl}/lib \
          tcc.c
        # libtcc1.a
        rm -f libtcc1.a
        ./tcc-musl -c -D HAVE_CONFIG_H=1 lib/libtcc1.c
        ./tcc-musl -c -D HAVE_CONFIG_H=1 lib/alloca.S
        if [ aarch64-linux = "${buildPlatform.system}" ]; then
          ./tcc-musl -g -c -D HAVE_CONFIG_H=1 lib/lib-arm64.c
          ./tcc-musl -ar cr libtcc1.a libtcc1.o alloca.o lib-arm64.o
        else
          ./tcc-musl -ar cr libtcc1.a libtcc1.o alloca.o
        fi

        # Install
        install -D tcc-musl $out/bin/tcc
        install -Dm444 libtcc1.a $out/lib/libtcc1.a
      '';
in
{
  compiler = bash.runCommand "${pname}-${version}-compiler" {
    inherit pname version meta;
    passthru.tests.hello-world =
      result:
      bash.runCommand "${pname}-simple-program-${version}" { } ''
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

  libs =
    bash.runCommand "${pname}-${version}-libs"
      {
        inherit pname version meta;
      }
      ''
        mkdir $out
        cp -r ${musl}/* $out
        chmod +w $out/lib/libtcc1.a
        cp ${tinycc-musl}/lib/libtcc1.a $out/lib/libtcc1.a
      '';
}
