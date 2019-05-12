{ stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, gettext, libtool, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  name = "mergerfs-${version}";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = "mergerfs";
    rev = version;
    sha256 = "1arq09rn1lmvv7gj3ymwdiygm620zdcx1jh2qpa1dxrdg8xrwqa9";
  };

  nativeBuildInputs = [
    automake autoconf pkgconfig gettext libtool pandoc which
  ];
  buildInputs = [ attr libiconv ];

  preConfigure = ''
    cat > src/version.hpp <<EOF
    #pragma once
    static const char MERGERFS_VERSION[] = "${version}";
    EOF
  '';

  makeFlags = [ "PREFIX=$(out)" "XATTR_AVAILABLE=1" ];

  postFixup = ''
    ln -s $out/bin/mergerfs $out/bin/mount.fuse.mergerfs
  '';

  meta = {
    description = "A FUSE based union filesystem";
    homepage = https://github.com/trapexit/mergerfs;
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jfrankenau makefu ];
  };
}
