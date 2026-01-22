{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  pkg-config,
  gettext,
  libtool,
  pandoc,
  which,
  attr,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "mergerfs";
  version = "2.41.1";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = version;
    sha256 = "sha256-pXge+/5Ti4+e0aSbWLg6roIcg+3foAvSHP/Obd0EiE4=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=unused-result"
    "-Wno-error=maybe-uninitialized"

    # NOTE: _FORTIFY_SOURCE requires compiling with optimization (-O)
    "-O"
  ];

  nativeBuildInputs = [
    automake
    autoconf
    pkg-config
    gettext
    libtool
    pandoc
    which
  ];

  buildInputs = [
    attr
    libiconv
  ];

  preConfigure = ''
    echo "${version}" > VERSION
  '';

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "XATTR_AVAILABLE=1"
    "PREFIX=/"
    "SBINDIR=/bin"
    "CHMOD=true"
    "CHOWN=true"
  ];
  enableParallelBuilding = true;

  postFixup = ''
    ln -srf $out/bin/mergerfs $out/bin/mount.fuse.mergerfs
    ln -srf $out/bin/mergerfs $out/bin/mount.mergerfs
  '';

  meta = {
    description = "FUSE based union filesystem";
    homepage = "https://github.com/trapexit/mergerfs";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
