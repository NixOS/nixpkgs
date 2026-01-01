{
  lib,
  kaem,
  mes-libc,
<<<<<<< HEAD
  buildPlatform,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

rec {

  # Recompile libc: crt{1,n,i}, libtcc.a, libc.a, libgetopt.a
  recompileLibc =
    {
      tcc,
      pname,
      version,
      src,
      libtccOptions,
<<<<<<< HEAD
      libtccSources ? [
        "${src}/lib/libtcc1.c"
        "${src}/lib/va_list.c"
      ],
      libtccObjects ? [
        "libtcc1.o"
        "va_list.o"
      ],
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    }:
    let

      crt = kaem.runCommand "crt" { } ''
        mkdir -p ''${out}/lib
        ${tcc}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crt1.o ${mes-libc}/lib/crt1.c
        ${tcc}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crtn.o ${mes-libc}/lib/crtn.c
        ${tcc}/bin/tcc ${mes-libc.CFLAGS} -c -o ''${out}/lib/crti.o ${mes-libc}/lib/crti.c
      '';

      library =
<<<<<<< HEAD
        let
          compileCmd = options: source: "${tcc}/bin/tcc ${options} -c ${source}";
        in
        libName: options: sources: objs:
        kaem.runCommand "${libName}.a" { } ''
          ${lib.strings.concatMapStringsSep "\n" (compileCmd options) sources}
          ${tcc}/bin/tcc -ar cr ''${out} ${lib.strings.concatStringsSep " " objs}
        '';

      libtcc1 = library "libtcc1" libtccOptions libtccSources libtccObjects;
      libc = library "libc" mes-libc.CFLAGS [ "${mes-libc}/lib/libc.c" ] [ "libc.o" ];
      libgetopt = library "libgetopt" mes-libc.CFLAGS [ "${mes-libc}/lib/libgetopt.c" ] [ "libgetopt.o" ];
=======
        lib: options: source:
        kaem.runCommand "${lib}.a" { } ''
          ${tcc}/bin/tcc ${options} -c -o ${lib}.o ${source}
          ${tcc}/bin/tcc -ar cr ''${out} ${lib}.o
        '';

      libtcc1 = library "libtcc1" libtccOptions "${src}/lib/libtcc1.c";
      libc = library "libc" mes-libc.CFLAGS "${mes-libc}/lib/libc.c";
      libgetopt = library "libgetopt" mes-libc.CFLAGS "${mes-libc}/lib/libgetopt.c";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    in
    kaem.runCommand "${pname}-libs-${version}" { } ''
      mkdir -p ''${out}/lib
      cp ${crt}/lib/crt1.o ''${out}/lib
      cp ${crt}/lib/crtn.o ''${out}/lib
      cp ${crt}/lib/crti.o ''${out}/lib
      cp ${libtcc1} ''${out}/lib/libtcc1.a
      cp ${libc} ''${out}/lib/libc.a
      cp ${libgetopt} ''${out}/lib/libgetopt.a
    '';

  buildTinyccMes =
    {
      pname,
      version,
      src,
      prev,
      buildOptions,
<<<<<<< HEAD
      libtccSources ? [
        "${src}/lib/libtcc1.c"
        "${src}/lib/va_list.c"
      ],
      libtccObjects ? [
        "libtcc1.o"
        "va_list.o"
      ],
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      libtccBuildOptions,
      meta,
    }:
    let
<<<<<<< HEAD
      tccTarget =
        {
          i686-linux = "I386";
          x86_64-linux = "X86_64";
        }
        .${buildPlatform.system};
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      options = lib.strings.concatStringsSep " " buildOptions;
      libtccOptions = lib.strings.concatStringsSep " " (
        [
          "-c"
          "-D"
<<<<<<< HEAD
          "TCC_TARGET_${tccTarget}=1"
=======
          "TCC_TARGET_I386=1"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        ]
        ++ libtccBuildOptions
      );
      compiler =
        kaem.runCommand "${pname}-${version}"
          {
            inherit pname version meta;
            passthru.tests = {
              get-version =
                result:
                kaem.runCommand "${pname}-get-version-${version}" { } ''
                  ${result}/bin/tcc -version
                  mkdir ''${out}
                '';
              chain =
                result:
                kaem.runCommand "${pname}-chain-${version}" { } ''
                  echo ${prev.compiler.tests.chain or prev.compiler.tests.get-version};
                  ${result}/bin/tcc -version
                  mkdir ''${out}
                '';
            };
          }
          ''
            catm config.h
            mkdir -p ''${out}/bin
            ${prev.compiler}/bin/tcc \
              -B ${prev.libs}/lib \
              -g \
              -v \
              -o ''${out}/bin/tcc \
              -D BOOTSTRAP=1 \
              ${options} \
              -I . \
              -I ${src} \
<<<<<<< HEAD
              -D TCC_TARGET_${tccTarget}=1 \
=======
              -D TCC_TARGET_I386=1 \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
              -D CONFIG_TCCDIR=\"\" \
              -D CONFIG_SYSROOT=\"\" \
              -D CONFIG_TCC_CRTPREFIX=\"{B}\" \
              -D CONFIG_TCC_ELFINTERP=\"\" \
              -D CONFIG_TCC_LIBPATHS=\"{B}\" \
<<<<<<< HEAD
              -D CONFIG_TCC_SYSINCLUDEPATHS=\"${src}/include:${mes-libc}/include\" \
=======
              -D CONFIG_TCC_SYSINCLUDEPATHS=\"${mes-libc}/include\" \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
              -D TCC_LIBGCC=\"libc.a\" \
              -D TCC_LIBTCC1=\"libtcc1.a\" \
              -D CONFIG_TCCBOOT=1 \
              -D CONFIG_TCC_STATIC=1 \
              -D CONFIG_USE_LIBGCC=1 \
              -D TCC_MES_LIBC=1 \
<<<<<<< HEAD
              -D TCC_VERSION=\"0.9.28-${version}\" \
=======
              -D TCC_VERSION=\"${version}\" \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
              -D ONE_SOURCE=1 \
              ${src}/tcc.c
          '';
      libs = recompileLibc {
        inherit
          pname
          version
          src
          libtccOptions
<<<<<<< HEAD
          libtccSources
          libtccObjects
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
          ;
        tcc = compiler;
      };
    in
    {
      inherit prev compiler libs;
    };
}
