{
  lib, stdenv, buildPackages, fetchurl,
  runCommand,
  autoconf, automake, libtool,
  enablePython ? false, python ? null,
}:

assert enablePython -> python != null;

stdenv.mkDerivation rec {
  pname = "audit";
  version = "3.0.1";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/audit/${pname}-${version}.tar.gz";
    sha256 = "19am244hfgiwn1dvyy5jx7qk0bl3c4sffb1wg84g6hzxv1844k4r";
  };

  outputs = [ "bin" "dev" "out" "man" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isMusl
    [ autoconf automake libtool ];
  buildInputs = lib.optional enablePython python;

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
    ./fix-duplicate-interpret.patch
  ];

  prePatch = ''
    sed -i 's,#include <sys/poll.h>,#include <poll.h>\n#include <limits.h>,' audisp/audispd.c
  '';

  meta = {
    description = "Audit Library";
    homepage = "https://people.redhat.com/sgrubb/audit/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
