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
<<<<<<< HEAD
  version = "2.41.1";
=======
  version = "2.40.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-pXge+/5Ti4+e0aSbWLg6roIcg+3foAvSHP/Obd0EiE4=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=unused-result"
    "-Wno-error=maybe-uninitialized"

    # NOTE: _FORTIFY_SOURCE requires compiling with optimization (-O)
    "-O"
  ];

=======
    sha256 = "sha256-3DfSGuTtM+h0IdtsIhLVXQxX5/Tj9G5Qcha3DWmyyq4=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    automake
    autoconf
    pkg-config
    gettext
    libtool
    pandoc
    which
  ];
<<<<<<< HEAD

=======
  prePatch = ''
    sed -i -e '/chown/d' -e '/chmod/d' libfuse/Makefile
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    "CHMOD=true"
    "CHOWN=true"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
