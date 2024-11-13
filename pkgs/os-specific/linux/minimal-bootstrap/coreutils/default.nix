{ lib
, fetchurl
, kaem
, tinycc
, gnumake
, gnupatch
}:
let
  pname = "bootstrap-coreutils";
  version = "5.0";

  src = fetchurl {
    url = "mirror://gnu/coreutils/coreutils-${version}.tar.gz";
    sha256 = "10wq6k66i8adr4k08p0xmg87ff4ypiazvwzlmi7myib27xgffz62";
  };

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/a8752029f60217a5c41c548b16f5cdd2a1a0e0db/sysa/coreutils-5.0/coreutils-5.0.kaem
  liveBootstrap = "https://github.com/fosslinux/live-bootstrap/raw/a8752029f60217a5c41c548b16f5cdd2a1a0e0db/sysa/coreutils-5.0";

  makefile = fetchurl {
    url = "${liveBootstrap}/mk/main.mk";
    sha256 = "0njg4xccxfqrslrmlb8ls7h6hlnfmdx42nvxwmca8flvczwrplfd";
  };

  patches = [
    # modechange.h uses functions defined in sys/stat.h, so we need to move it to
    # after sys/stat.h include.
    (fetchurl {
      url = "${liveBootstrap}/patches/modechange.patch";
      sha256 = "04xa4a5w2syjs3xs6qhh8kdzqavxnrxpxwyhc3qqykpk699p3ms5";
    })
    # mbstate_t is a struct that is required. However, it is not defined by mes libc.
    (fetchurl {
      url = "${liveBootstrap}/patches/mbstate.patch";
      sha256 = "0rz3c0sflgxjv445xs87b83i7gmjpl2l78jzp6nm3khdbpcc53vy";
    })
    # strcoll() does not exist in mes libc, change it to strcmp.
    (fetchurl {
      url = "${liveBootstrap}/patches/ls-strcmp.patch";
      sha256 = "0lx8rz4sxq3bvncbbr6jf0kyn5bqwlfv9gxyafp0541dld6l55p6";
    })
    # getdate.c is pre-compiled from getdate.y
    # At this point we don't have bison yet and in any case getdate.y does not
    # compile when generated with modern bison.
    (fetchurl {
      url = "${liveBootstrap}/patches/touch-getdate.patch";
      sha256 = "1xd3z57lvkj7r8vs5n0hb9cxzlyp58pji7d335snajbxzwy144ma";
    })
    # touch: add -h to change symlink timestamps, where supported
    (fetchurl {
      url = "${liveBootstrap}/patches/touch-dereference.patch";
      sha256 = "0wky5r3k028xwyf6g6ycwqxzc7cscgmbymncjg948vv4qxsxlfda";
    })
    # strcoll() does not exist in mes libc, change it to strcmp.
    (fetchurl {
      url = "${liveBootstrap}/patches/expr-strcmp.patch";
      sha256 = "19f31lfsm1iwqzvp2fyv97lmqg4730prfygz9zip58651jf739a9";
    })
    # strcoll() does not exist in mes libc, change it to strcmp.
    # hard_LC_COLLATE is used but not declared when HAVE_SETLOCALE is unset.
    (fetchurl {
      url = "${liveBootstrap}/patches/sort-locale.patch";
      sha256 = "0bdch18mpyyxyl6gyqfs0wb4pap9flr11izqdyxccx1hhz0a2i6c";
    })
    # don't assume fopen cannot return stdin or stdout.
    (fetchurl {
      url = "${liveBootstrap}/patches/uniq-fopen.patch";
      sha256 = "0qs6shyxl9j4h34v5j5sgpxrr4gjfljd2hxzw416ghwc3xzv63fp";
    })
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
    description = "GNU Core Utilities";
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
