{ lib
, kaem
, mes-libc
, ln-boot
}:
{
  buildTinyccMes = {
    pname,
    version,
    src,
    prev,
    buildOptions,
    libtccBuildOptions,
    meta
  }:
    let
      options = lib.strings.concatStringsSep " " buildOptions;
      libtccOptions = lib.strings.concatStringsSep " " libtccBuildOptions;
    in
    kaem.runCommand "${pname}-${version}" {
      inherit pname version meta;
      nativeBuildInputs = [ ln-boot ];
    } ''
      catm config.h
      mkdir -p ''${out}/bin
      ${prev}/bin/tcc \
        -g \
        -v \
        -static \
        -o ''${out}/bin/tcc \
        -D BOOTSTRAP=1 \
        ${options} \
        -I . \
        -I ${src} \
        -D TCC_TARGET_I386=1 \
        -D CONFIG_TCCDIR=\"''${out}/lib\" \
        -D CONFIG_TCC_CRTPREFIX=\"''${out}/lib\" \
        -D CONFIG_TCC_ELFINTERP=\"\" \
        -D CONFIG_TCC_LIBPATHS=\"''${out}/lib\" \
        -D CONFIG_TCC_SYSINCLUDEPATHS=\"${mes-libc}/include:${src}/include\" \
        -D TCC_LIBGCC=\"libc.a\" \
        -D TCC_LIBTCC1=\"libtcc1.a\" \
        -D CONFIG_TCCBOOT=1 \
        -D CONFIG_TCC_STATIC=1 \
        -D CONFIG_USE_LIBGCC=1 \
        -D TCC_MES_LIBC=1 \
        -D TCC_VERSION=\"${version}\" \
        -D ONE_SOURCE=1 \
        -L ${prev}/lib \
        ${src}/tcc.c

      ''${out}/bin/tcc -v

      # Recompile libc: crt{1,n,i}, libtcc.a, libc.a, libgetopt.a
      mkdir -p ''${out}/lib
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crt1.o ${mes-libc}/lib/crt1.c
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crtn.o ${mes-libc}/lib/crtn.c
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crti.o ${mes-libc}/lib/crti.c
      ''${out}/bin/tcc -c -D TCC_TARGET_I386=1 ${libtccOptions} -o libtcc1.o ${src}/lib/libtcc1.c
      ''${out}/bin/tcc -ar cr ''${out}/lib/libtcc1.a libtcc1.o
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o libc.o ${mes-libc}/lib/libc.c
      ''${out}/bin/tcc -ar cr ''${out}/lib/libc.a libc.o
      ''${out}/bin/tcc ${mes-libc.CFLAGS} -c -o libgetopt.o ${mes-libc}/lib/libgetopt.c
      ''${out}/bin/tcc -ar cr ''${out}/lib/libgetopt.a libgetopt.o

      # Install headers
      ln -s ${mes-libc}/include ''${out}/include
    '';
}
