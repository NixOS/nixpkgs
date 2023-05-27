{ lib
, fetchurl
, kaem
, tinycc
, gnumake
, gnupatch
, live-bootstrap
}:
let
  pname = "coreutils";
  version = "5.0";

  src = fetchurl {
    url = "mirror://gnu/coreutils/coreutils-${version}.tar.gz";
    sha256 = "10wq6k66i8adr4k08p0xmg87ff4ypiazvwzlmi7myib27xgffz62";
  };

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/a8752029f60217a5c41c548b16f5cdd2a1a0e0db/sysa/coreutils-5.0/coreutils-5.0.kaem
  lbf = live-bootstrap.packageFiles {
    commit = "a8752029f60217a5c41c548b16f5cdd2a1a0e0db";
    parent = "sysa";
    inherit pname version;
  };

  makefile = lbf."mk/main.mk";

  patches = [
    # modechange.h uses functions defined in sys/stat.h, so we need to move it to
    # after sys/stat.h include.
    lbf."patches/modechange.patch"
    # mbstate_t is a struct that is required. However, it is not defined by mes libc.
    lbf."patches/mbstate.patch"
    # strcoll() does not exist in mes libc, change it to strcmp.
    lbf."patches/ls-strcmp.patch"
    # getdate.c is pre-compiled from getdate.y
    # At this point we don't have bison yet and in any case getdate.y does not
    # compile when generated with modern bison.
    lbf."patches/touch-getdate.patch"
    # touch: add -h to change symlink timestamps, where supported
    lbf."patches/touch-dereference.patch"
    # strcoll() does not exist in mes libc, change it to strcmp.
    lbf."patches/expr-strcmp.patch"
    # strcoll() does not exist in mes libc, change it to strcmp.
    # hard_LC_COLLATE is used but not declared when HAVE_SETLOCALE is unset.
    lbf."patches/sort-locale.patch"
    # don't assume fopen cannot return stdin or stdout.
    lbf."patches/uniq-fopen.patch"
  ];
in
kaem.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    tinycc.compiler
    gnumake
    gnupatch
  ];

  meta = with lib; {
    description = "The GNU Core Utilities";
    homepage = "https://www.gnu.org/software/coreutils";
    license = licenses.gpl3Plus;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  ungz --file ${src} --output coreutils.tar
  untar --file coreutils.tar
  rm coreutils.tar
  cd coreutils-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np0 -i ${f}") patches}

  # Configure
  catm config.h
  cp lib/fnmatch_.h lib/fnmatch.h
  cp lib/ftw_.h lib/ftw.h
  cp lib/search_.h lib/search.h
  rm src/dircolors.h

  # Build
  make -f ${makefile} \
    CC="tcc -B ${tinycc.libs}/lib" \
    PREFIX=''${out}

  # Check
  ./src/echo "Hello coreutils!"

  # Install
  ./src/mkdir -p ''${out}/bin
  make -f ${makefile} install PREFIX=''${out}
''
