{ stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, gettext, libtool, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  pname = "mergerfs";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = version;
    sha256 = "0j7nbxzv85as76glzk4cf7j6ggfihcjaihp06s0zcar4i7zaiy9z";
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
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jfrankenau makefu ];
  };
}
