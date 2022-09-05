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
  version = "2.8.5"; # at the next release, remove the patches below!

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/audit/audit-${version}.tar.gz";
    sha256 = "1dzcwb2q78q7x41shcachn7f4aksxbxd470yk38zh03fch1l2p8f";
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

  # TODO: Remove the musl patches when
  #         https://github.com/linux-audit/audit-userspace/pull/25
  #       is available with the next release.
  patches = [
    ./patches/weak-symbols.patch
    (fetchpatch {
      # upstream build fix against -fno-common compilers like >=gcc-10
      url = "https://github.com/linux-audit/audit-userspace/commit/017e6c6ab95df55f34e339d2139def83e5dada1f.patch";
      sha256 = "100xa1rzkv0mvhjbfgpfm72f7c4p68syflvgc3xm6pxgrqqmfq8h";
    })

    (
      let patch = fetchpatch {
            url = "https://github.com/linux-audit/audit-userspace/commit/d579a08bb1cde71f939c13ac6b2261052ae9f77e.patch";
            name = "Add-substitue-functions-for-strndupa-rawmemchr.patch";
            sha256 = "015bvzflg1s1k5viap30nznlpjj44a66khyc8yq0waa68qwvdlsd";
          };
      in
        runCommand "Add-substitue-functions-for-strndupa-rawmemchr.patch-fix-copyright-merge-conflict" {} ''
          cp ${patch} $out
          substituteInPlace $out --replace \
              '-* Copyright (c) 2007-09,2011-16,2018 Red Hat Inc., Durham, North Carolina.' \
              '-* Copyright (c) 2007-09,2011-16 Red Hat Inc., Durham, North Carolina.'
        ''
    )

    # upstream fix for linux-headers-5.15 which removed ipx.h
    (fetchpatch {
      name = "no-ipx.patch";
      url = "https://github.com/linux-audit/audit-userspace/commit/6b09724c69d91668418ddb3af00da6db6755208c.patch";
      sha256 = "0qjq41ridyamajz9v9nyplgq7f8nn3fxw375s9sa5a0igsrx9pm0";
      excludes = [ "ChangeLog" ];
    })
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
  ''
  # According to https://stackoverflow.com/questions/13089166
  # --whole-archive linker flag is required to be sure that linker
  # correctly chooses strong version of symbol regardless of order of
  # object files at command line.
  + lib.optionalString stdenv.hostPlatform.isStatic ''
    export LDFLAGS=-Wl,--whole-archive
  '';
  meta = {
    description = "Audit Library";
    homepage = "https://people.redhat.com/sgrubb/audit/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
