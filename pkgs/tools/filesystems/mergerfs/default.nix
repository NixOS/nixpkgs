{ stdenv, fetchFromGitHub, automake, autoconf, pkgconfig, gettext, libtool, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  name = "mergerfs-${version}";
  version = "2.24.2";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = "mergerfs";
    rev = version;
    sha256 = "0i65v7900s7c9jkj3a4v44vf3r5mvjkbcic3df940nmk0clahhcs";
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

  meta = {
    description = "A FUSE based union filesystem";
    homepage = https://github.com/trapexit/mergerfs;
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jfrankenau makefu ];
  };
}
