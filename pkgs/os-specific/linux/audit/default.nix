{
  stdenv, buildPackages, fetchurl, fetchpatch,
  runCommand,
  autoconf, automake, libtool,
  enablePython ? false, python ? null,
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.8.5"; # at the next release, remove the patches below!

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "1dzcwb2q78q7x41shcachn7f4aksxbxd470yk38zh03fch1l2p8f";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = stdenv.lib.optionals stdenv.hostPlatform.isMusl
    [ autoconf automake libtool ];
  buildInputs = stdenv.lib.optional enablePython python;

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
  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl [
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
  ];

  prePatch = ''
    sed -i 's,#include <sys/poll.h>,#include <poll.h>\n#include <limits.h>,' audisp/audispd.c
  '';
  meta = {
    description = "Audit Library";
    homepage = https://people.redhat.com/sgrubb/audit/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
