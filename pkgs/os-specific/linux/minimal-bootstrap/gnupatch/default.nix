{
  lib,
  fetchurl,
  kaem,
  tinycc,
}:
let
  pname = "gnupatch";
  # 2.6.x and later use features not implemented in mes-libc (eg. quotearg.h)
  version = "2.5.9";

  src = fetchurl {
    url = "mirror://gnu/patch/patch-${version}.tar.gz";
    sha256 = "12nv7jx3gxfp50y11nxzlnmqqrpicjggw6pcsq0wyavkkm3cddgc";
  };

  # Thanks to the live-bootstrap project!
  # https://github.com/fosslinux/live-bootstrap/blob/1bc4296091c51f53a5598050c8956d16e945b0f5/sysa/patch-2.5.9/mk/main.mk
  CFLAGS = [
    "-I."
    "-DHAVE_DECL_GETENV"
    "-DHAVE_DECL_MALLOC"
    "-DHAVE_DIRENT_H"
    "-DHAVE_LIMITS_H"
    "-DHAVE_GETEUID"
    "-DHAVE_MKTEMP"
    "-DPACKAGE_BUGREPORT="
    "-Ded_PROGRAM=\\\"/nullop\\\""
    "-Dmbstate_t=int" # When HAVE_MBRTOWC is not enabled uses of mbstate_t are always a no-op
    "-DRETSIGTYPE=int"
    "-DHAVE_MKDIR"
    "-DHAVE_RMDIR"
    "-DHAVE_FCNTL_H"
    "-DPACKAGE_NAME=\\\"patch\\\""
    "-DPACKAGE_VERSION=\\\"${version}\\\""
    "-DHAVE_MALLOC"
    "-DHAVE_REALLOC"
    "-DSTDC_HEADERS"
    "-DHAVE_STRING_H"
    "-DHAVE_STDLIB_H"
  ];

  # Maintenance note: List of sources from Makefile.in
  SRCS = [
    "addext.c"
    "argmatch.c"
    "backupfile.c"
    "basename.c"
    "dirname.c"
    "getopt.c"
    "getopt1.c"
    "inp.c"
    "maketime.c"
    "partime.c"
    "patch.c"
    "pch.c"
    "quote.c"
    "quotearg.c"
    "quotesys.c"
    "util.c"
    "version.c"
    "xmalloc.c"
  ];
  sources = SRCS ++ [
    # mes-libc doesn't implement `error()`
    "error.c"
  ];

  objects = map (x: lib.replaceStrings [ ".c" ] [ ".o" ] (baseNameOf x)) sources;
in
kaem.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [ tinycc.compiler ];

    meta = with lib; {
      description = "GNU Patch, a program to apply differences to files";
      homepage = "https://www.gnu.org/software/patch";
      license = licenses.gpl3Plus;
      teams = [ teams.minimal-bootstrap ];
      mainProgram = "patch";
      platforms = platforms.unix;
    };
  }
  ''
    # Unpack
    ungz --file ${src} --output patch.tar
    untar --file patch.tar
    rm patch.tar
    cd patch-${version}

    # Configure
    catm config.h

    # Build
    alias CC="tcc -B ${tinycc.libs}/lib ${lib.concatStringsSep " " CFLAGS}"
    ${lib.concatMapStringsSep "\n" (f: "CC -c ${f}") sources}

    # Link
    CC -o patch ${lib.concatStringsSep " " objects}

    # Check
    ./patch --version

    # Install
    mkdir -p ''${out}/bin
    cp ./patch ''${out}/bin
    chmod 555 ''${out}/bin/patch
  ''
