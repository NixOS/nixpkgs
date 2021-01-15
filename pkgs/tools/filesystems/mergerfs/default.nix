{ lib, stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, gettext, libtool, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  pname = "mergerfs";
  version = "2.32.0";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = version;
    sha256 = "1qmhwkl2ws0hwd7s1mzrdiw4h7jpilzcr0w8dgx465mdzb5d2jad";
  };

  nativeBuildInputs = [
    automake autoconf pkgconfig gettext libtool pandoc which
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
