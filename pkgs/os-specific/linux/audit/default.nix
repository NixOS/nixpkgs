{ lib
, stdenv
, fetchurl
, autoreconfHook
, bash
, buildPackages
, linuxHeaders
, python3
, swig

# Enabling python support while cross compiling would be possible, but the
# configure script tries executing python to gather info instead of relying on
# python3-config exclusively
, enablePython ? stdenv.hostPlatform == stdenv.buildPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "audit";
  version = "3.1.2";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/audit/audit-${finalAttrs.version}.tar.gz";
    hash = "sha256-wLF5LR8KiMbxgocQUJy7mHBZ/GhxLJdmnKkOrhA9KH0=";
  };

  postPatch = ''
    substituteInPlace bindings/swig/src/auditswig.i \
      --replace "/usr/include/linux/audit.h" \
                "${linuxHeaders}/include/linux/audit.h"
  '';

  outputs = [ "bin" "dev" "out" "man" ];

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    autoreconfHook
  ]
  ++ lib.optionals enablePython [
    python3
    swig
  ];

  buildInputs = [
    bash
  ];

  configureFlags = [
    # z/OS plugin is not useful on Linux, and pulls in an extra openldap
    # dependency otherwise
    "--disable-zos-remote"
    "--with-arm"
    "--with-aarch64"
    (if enablePython then "--with-python" else "--without-python")
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://people.redhat.com/sgrubb/audit/";
    description = "Audit Library";
    changelog = "https://github.com/linux-audit/audit-userspace/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
