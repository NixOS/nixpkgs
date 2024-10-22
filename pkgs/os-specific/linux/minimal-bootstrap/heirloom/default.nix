{ lib
, fetchurl
, bash
, tinycc
, gnumake
, gnupatch
, heirloom-devtools
, heirloom
}:
let
  pname = "heirloom";
  version = "070715";

  src = fetchurl {
    url = "mirror://sourceforge/heirloom/heirloom/${version}/heirloom-${version}.tar.bz2";
    sha256 = "sha256-6zP3C8wBmx0OCkHx11UtRcV6FicuThxIY07D5ESWow8=";
  };

  patches = [
    # we pre-generate nawk's proctab.c as meslibc is not capable of running maketab
    # during build time (insufficient sscanf support)
    ./proctab.patch

    # disable utilities that don't build successfully
    ./disable-programs.patch

    # "tcc -ar" doesn't support creating empty archives
    ./tcc-empty-ar.patch
    # meslibc doesn't have seperate libm
    ./dont-link-lm.patch
    # meslibc's vprintf doesn't support %ll
    ./vprintf.patch
    # meslibc doesn't support sysconf()
    ./sysconf.patch
    # meslibc doesn't support locale
    ./strcoll.patch
    # meslibc doesn't support termios.h
    ./termios.patch
    # meslibc doesn't support utime.h
    ./utime.patch
    # meslibc doesn't support langinfo.h
    ./langinfo.patch
    # support building with meslibc
    ./meslibc-support.patch
    # remove socket functionality as unsupported by meslibc
    ./cp-no-socket.patch
  ];

  makeFlags = [
    # mk.config build options
    "CC='tcc -B ${tinycc.libs}/lib -include ${./stubs.h} -include ${./musl.h}'"
    "AR='tcc -ar'"
    "RANLIB=true"
    "STRIP=true"
    "SHELL=${bash}/bin/sh"
    "POSIX_SHELL=${bash}/bin/sh"
    "DEFBIN=/bin"
    "SV3BIN=/5bin"
    "S42BIN=/5bin/s42"
    "SUSBIN=/bin"
    "SU3BIN=/5bin/posix2001"
    "UCBBIN=/ucb"
    "CCSBIN=/ccs/bin"
    "DEFLIB=/lib"
    "DEFSBIN=/bin"
    "MANDIR=/share/man"
    "LCURS=" # disable ncurses
    "USE_ZLIB=0" # disable zlib
    "IWCHAR='-I../libwchar'"
    "LWCHAR='-L../libwchar -lwchar'"
  ];
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    tinycc.compiler
    gnumake
    gnupatch
    heirloom-devtools
  ];

  passthru.sed =
    bash.runCommand "${pname}-sed-${version}" {} ''
      install -D ${heirloom}/bin/sed $out/bin/sed
    '';

  passthru.tests.get-version = result:
    bash.runCommand "${pname}-get-version-${version}" {} ''
      ${result}/bin/banner Hello Heirloom
      mkdir $out
    '';

  meta = with lib; {
    description = "Heirloom Toolchest is a collection of standard Unix utilities";
    homepage = "https://heirloom.sourceforge.net/tools.html";
    license = with licenses; [
      # All licenses according to LICENSE/
      zlib
      caldera
      bsdOriginalUC
      cddl
      bsd3
      gpl2Plus
      lgpl21Plus
      lpl-102
      info-zip
    ];
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.unix;
  };
} ''
  # Unpack
  unbz2 --file ${src} --output heirloom.tar
  untar --file heirloom.tar
  rm heirloom.tar
  cd heirloom-${version}

  # Patch
  ${lib.concatMapStringsSep "\n" (f: "patch -Np0 -i ${f}") patches}
  cp ${./proctab.c} nawk/proctab.c

  # Build
  # These tools are required during later build steps
  export PATH="$PATH:$PWD/ed:$PWD/nawk:$PWD/sed"
  make ${lib.concatStringsSep " " makeFlags}

  # Install
  make install ROOT=$out ${lib.concatStringsSep " " makeFlags}
''
