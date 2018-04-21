{
  stdenv, buildPackages, fetchurl, fetchpatch,
  enablePython ? false, python ? null,
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  name = "audit-2.8.3";

  src = fetchurl {
    url = "http://people.redhat.com/sgrubb/audit/${name}.tar.gz";
    sha256 = "06lacv9zjn0sf076dydwmvjhdmik3xzhdjvyrkq75917xv54ajbl";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  buildInputs = stdenv.lib.optional enablePython python;

  configureFlags = [
    # z/OS plugin is not useful on Linux,
    # and pulls in an extra openldap dependency otherwise
    "--disable-zos-remote"
    (if enablePython then "--with-python" else "--without-python")
  ];

  enableParallelBuilding = true;

  patches = stdenv.lib.optional stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/audit/0002-auparse-remove-use-of-rawmemchr.patch?id=3e57180fdf3f90c30a25aea44f57846efc93a696";
      name = "0002-auparse-remove-use-of-rawmemchr.patch";
      sha256 = "1caaqbfgb2rq3ria5bz4n8x30ihgihln6w9w9a46k62ba0wh9rkz";
    })
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/audit/0003-all-get-rid-of-strndupa.patch?id=3e57180fdf3f90c30a25aea44f57846efc93a696";
      name = "0003-all-get-rid-of-strndupa.patch";
      sha256 = "1ddrm6a0ijrf7caw1wpw2kkbjp2lkxkmc16v51j5j7dvdalc6591";
    })
  ];

  prePatch = ''
    sed -i 's,#include <sys/poll.h>,#include <poll.h>\n#include <limits.h>,' audisp/audispd.c
  '';
  meta = {
    description = "Audit Library";
    homepage = http://people.redhat.com/sgrubb/audit/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
