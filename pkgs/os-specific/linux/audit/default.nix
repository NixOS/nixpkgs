{
  lib, stdenv, buildPackages, fetchurl, fetchpatch,
  runCommand,
  autoreconfHook,
  autoconf, automake, libtool, bash,
  # Enabling python support while cross compiling would be possible, but
  # the configure script tries executing python to gather info instead of
  # relying on python3-config exclusively
  enablePython ? stdenv.hostPlatform == stdenv.buildPlatform, python3, swig,
  linuxHeaders ? stdenv.cc.libc.linuxHeaders
}:

stdenv.mkDerivation rec {
  pname = "audit";
  version = "3.1";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/audit/audit-${version}.tar.gz";
    sha256 = "sha256-tc882rsnhsCLHeNZmjsaVH5V96n5wesgePW0TPROg3g=";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook ]
    ++ lib.optionals enablePython [ python3 swig ];
  buildInputs = [ bash ];

  configureFlags = [
    # z/OS plugin is not useful on Linux,
    # and pulls in an extra openldap dependency otherwise
    "--disable-zos-remote"
    (if enablePython then "--with-python" else "--without-python")
    "--with-arm"
    "--with-aarch64"
  ];

  enableParallelBuilding = true;
  patches = [
    ./fix-static.patch

    # Fix pending upstream inclusion for linux-headers-5.17 support:
    #  https://github.com/linux-audit/audit-userspace/pull/253
    (fetchpatch {
      name = "ignore-flexible-array.patch";
      url = "https://github.com/linux-audit/audit-userspace/commit/beed138222421a2eb4212d83cb889404bd7efc49.patch";
      sha256 = "1hf02zaxv6x0wmn4ca9fj48y2shks7vfna43i1zz58xw9jq7sza0";
    })
  ];

  postPatch = ''
    sed -i 's,#include <sys/poll.h>,#include <poll.h>\n#include <limits.h>,' audisp/audispd.c
    substituteInPlace bindings/swig/src/auditswig.i \
      --replace "/usr/include/linux/audit.h" \
                "${linuxHeaders}/include/linux/audit.h"
  '';
  meta = {
    description = "Audit Library";
    homepage = "https://people.redhat.com/sgrubb/audit/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
