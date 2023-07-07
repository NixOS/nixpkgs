{ lib, stdenv, fetchFromGitHub, automake, autoconf, pkg-config, gettext, libtool, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  pname = "mergerfs";
  version = "2.35.1";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = version;
    sha256 = "sha256-mUnjWMxeZJ9wIpJJDqQIUk2x7oifZ/b2HZlPtQ77q8U=";
  };

  nativeBuildInputs = [
    automake autoconf pkg-config gettext libtool pandoc which
  ];
  prePatch = ''
    sed -i -e '/chown/d' -e '/chmod/d' libfuse/Makefile
  '';
  buildInputs = [ attr libiconv ];

  preConfigure = ''
    echo "${version}" > VERSION
  '';

  makeFlags = [ "DESTDIR=${placeholder "out"}" "XATTR_AVAILABLE=1" "PREFIX=/" "SBINDIR=/bin" ];
  enableParallelBuilding = true;

  postFixup = ''
    ln -srf $out/bin/mergerfs $out/bin/mount.fuse.mergerfs
    ln -srf $out/bin/mergerfs $out/bin/mount.mergerfs
  '';

  meta = {
    description = "A FUSE based union filesystem";
    homepage = "https://github.com/trapexit/mergerfs";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jfrankenau makefu ];
  };
}
