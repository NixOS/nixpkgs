{ lib, stdenv, linuxHeaders, freebsd, runCommandCC, buildPackages }:

stdenv.mkDerivation {
  pname = "evdev-proto";
  inherit (linuxHeaders) version;

  src = freebsd.ports;

  sourceRoot = "${freebsd.ports.name}/devel/evdev-proto";

  useTempPrefix = true;

  nativeBuildInputs = [ freebsd.makeMinimal ];

  ARCH = freebsd.makeMinimal.MACHINE_ARCH;
  OPSYS = "FreeBSD";
  _OSRELEASE = "${lib.versions.majorMinor freebsd.makeMinimal.version}-RELEASE";

  AWK = "awk";
  CHMOD = "chmod";
  FIND = "find";
  MKDIR = "mkdir -p";
  PKG_BIN = "${buildPackages.pkg}/bin/pkg";
  RM = "rm -f";
  SED = "${buildPackages.freebsd.sed}/bin/sed";
  SETENV = "env";
  SH = "sh";
  TOUCH = "touch";
  XARGS = "xargs";

  ABI_FILE = runCommandCC "abifile" {} "$CC -shared -o $out";
  CLEAN_FETCH_ENV = true;
  INSTALL_AS_USER = true;
  NO_CHECKSUM = true;
  NO_MTREE = true;
  SRC_BASE = freebsd.source;

  preUnpack = ''
    export MAKE_JOBS_NUMBER="$NIX_BUILD_CORES"

    export DISTDIR="$PWD/distfiles"
    export PKG_DBDIR="$PWD/pkg"
    export PREFIX="$prefix"

    mkdir -p "$DISTDIR/evdev-proto"
    tar -C "$DISTDIR/evdev-proto" \
        -xf ${linuxHeaders.src} \
        --strip-components 4 \
        linux-${linuxHeaders.version}/include/uapi/linux
  '';

  makeFlags = [ "DIST_SUBDIR=evdev-proto" ];

  postInstall = ''
    mv $prefix $out
  '';

  meta = with lib; {
    description = "Input event device header files for FreeBSD";
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.freebsd;
    license = licenses.gpl2Only;
  };
}
