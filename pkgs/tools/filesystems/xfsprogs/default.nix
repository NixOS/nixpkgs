{ lib, stdenv, buildPackages, fetchurl, autoconf, automake, gettext, libtool, pkg-config
, icu, libuuid, readline, inih, liburcu
}:

stdenv.mkDerivation rec {
  pname = "xfsprogs";
  version = "6.1.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/fs/xfs/xfsprogs/${pname}-${version}.tar.xz";
    hash = "sha256-7OuQFcTr76VvqF+v91bMtR7Sz5w5uiOXZ/jnhwXoUlE=";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoconf automake libtool gettext pkg-config
    libuuid # codegen tool uses libuuid
  ];
  buildInputs = [ readline icu inih liburcu ];
  propagatedBuildInputs = [ libuuid ]; # Dev headers include <uuid/uuid.h>

  enableParallelBuilding = true;

  # @sbindir@ is replaced with /run/current-system/sw/bin to fix dependency cycles
  preConfigure = ''
    for file in scrub/{xfs_scrub_all.cron.in,xfs_scrub@.service.in,xfs_scrub_all.service.in}; do
      substituteInPlace "$file" \
        --replace '@sbindir@' '/run/current-system/sw/bin'
    done
    make configure
    patchShebangs ./install-sh
  '';

  configureFlags = [
    "--disable-lib64"
    "--with-systemd-unit-dir=${placeholder "out"}/lib/systemd/system"
  ];

  installFlags = [ "install-dev" ];

  # FIXME: forbidden rpath
  postInstall = ''
    find . -type d -name .libs | xargs rm -rf
  '';

  meta = with lib; {
    homepage = "https://xfs.org/";
    description = "SGI XFS utilities";
    license = with licenses; [ gpl2Only lgpl21 gpl3Plus ];  # see https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/debian/copyright
    platforms = platforms.linux;
    maintainers = with maintainers; [ dezgeg ajs124 ];
  };
}
