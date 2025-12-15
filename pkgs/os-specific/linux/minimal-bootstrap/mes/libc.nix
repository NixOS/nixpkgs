{
  lib,
  kaem,
  ln-boot,
  mes,
  mes-libc,
  buildPlatform,
  fetchurl,
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

  sources = (import ./sources.nix).${arch}.linux.gcc;
  inherit (sources) libtcc1_SOURCES libc_gnu_SOURCES;

  ldexpl = fetchurl {
    url = "https://gitlab.com/janneke/mes/-/raw/c837abed8edb341d4e56913729fbe9803b4de47c/lib/math/ldexpl.c";
    hash = "sha256-3QoFZZIqVmlMUosEqOdYIMEHzYgQ7GJ7Hz0Bf/1iIig=";
  };

  # Concatenate all source files into a convenient bundle
  # "gcc" variants of source files (eg. "lib/linux/x86-mes-gcc") can also be
  # compiled by tinycc
  #
  # Passing this many arguments is too much for kaem so we need to split
  # the operation in two
  firstLibc = (lib.take 100 libc_gnu_SOURCES) ++ [ ldexpl ];
  lastLibc = lib.drop 100 libc_gnu_SOURCES;
in
kaem.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [ ln-boot ];

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
    catm ''${TMPDIR}/first.c ${lib.concatStringsSep " " firstLibc}
    catm ''${out}/lib/libc.c ''${TMPDIR}/first.c ${lib.concatStringsSep " " lastLibc}

    # crt{1,n,i}.c
    cp lib/linux/${arch}-mes-gcc/crt1.c ''${out}/lib
    cp lib/linux/${arch}-mes-gcc/crtn.c ''${out}/lib
    cp lib/linux/${arch}-mes-gcc/crti.c ''${out}/lib

    # libtcc1.c
    catm ''${out}/lib/libtcc1.c ${lib.concatStringsSep " " libtcc1_SOURCES}

    # getopt.c
    cp lib/posix/getopt.c ''${out}/lib/libgetopt.c

    # Install headers
    ln -s ${mes.srcPrefix}/include ''${out}/include
  ''
