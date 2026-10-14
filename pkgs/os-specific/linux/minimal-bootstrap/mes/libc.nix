let
  sourcesJson = (builtins.fromJSON (builtins.readFile ./sources.json));
in

{
  lib,
  kaem,
  ln-boot,
  mes,
  buildPlatform,
}:
let
  pname = "mes-libc";
  inherit (mes.compiler) version;

  arch =
    {
      i686-linux = "x86";
      x86_64-linux = "x86_64";
    }
    .${buildPlatform.system};

  sources = sourcesJson."${arch}.linux.gcc";
  inherit (sources) libtcc1_SOURCES libc_gnu1_SOURCES libc_gnu2_SOURCES;

  # Concatenate all source files into a convenient bundle
  # "gcc" variants of source files (eg. "lib/linux/x86-mes-gcc") can also be
  # compiled by tinycc
  #
  # Passing this many arguments is too much for kaem so we need to split
  # the operation in two
  #
  # We also vendor a copy of ldexpl. We do not `fetchurl` it as the mes GitLab
  # often has force pushes and links are thus unstable.
  firstLibc = libc_gnu1_SOURCES + " " + ./ldexpl.c;
  lastLibc = libc_gnu2_SOURCES;
in
kaem.runCommand "${pname}-${version}"
  {
    inherit pname version;

    extraPath = "${ln-boot}/bin";

    passthru.CFLAGS = "-std=c11";

    meta = {
      description = "Mes C Library";
      homepage = "https://www.gnu.org/software/mes";
      license = lib.licenses.gpl3Plus;
      teams = [ lib.teams.minimal-bootstrap ];
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  }
  ''
    cd ${mes.srcPrefix}

    # mescc compiled libc.a
    mkdir -p ''${out}/lib/${arch}-mes

    # libc.c
    catm ''${TMPDIR}/first.c ${firstLibc}
    catm ''${out}/lib/libc.c ''${TMPDIR}/first.c ${lastLibc}

    # crt{1,n,i}.c
    cp lib/linux/${arch}-mes-gcc/crt1.c ''${out}/lib
    cp lib/linux/${arch}-mes-gcc/crtn.c ''${out}/lib
    cp lib/linux/${arch}-mes-gcc/crti.c ''${out}/lib

    # libtcc1.c
    catm ''${out}/lib/libtcc1.c ${libtcc1_SOURCES}

    # getopt.c
    cp lib/posix/getopt.c ''${out}/lib/libgetopt.c

    # Install headers
    ${ln-boot}/bin/ln -s ${mes.srcPrefix}/include ''${out}/include
  ''
