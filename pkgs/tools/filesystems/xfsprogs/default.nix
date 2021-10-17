{ lib, stdenv, buildPackages, fetchpatch, fetchurl, autoconf, automake, gettext, libtool, pkg-config
, icu, libuuid, readline, inih
}:

stdenv.mkDerivation rec {
  pname = "xfsprogs";
  version = "5.11.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/fs/xfs/xfsprogs/${pname}-${version}.tar.xz";
    sha256 = "0lxks616nmdk8zkdbwpq5sf9zz19smgy5rpmp3hpk2mvrl7kk70f";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  patches = [
    # Fix musl build
    (fetchpatch {
      name = "missing-signal.h";
      url = "https://git.alpinelinux.org/aports/plain/main/xfsprogs/missing-signal.h.patch?id=e0003b414d125ad32825014dcec2225df00f0a36";
      sha256 = "0a5fxw59d38b0zh1xjliv37gwq4c3fxa21j5sgy79ir9p9zns7vw";
    })
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoconf automake libtool gettext pkg-config
    libuuid # codegen tool uses libuuid
  ];
  buildInputs = [ readline icu inih ];
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
