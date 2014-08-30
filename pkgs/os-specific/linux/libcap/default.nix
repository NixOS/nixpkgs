{ stdenv, fetchurl, attr, perl }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-${version}";
  version = "2.22";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${name}.tar.bz2";
    sha256 = "03q50j6bg65cc501q87qh328ncav1i8qw2bjig99vxmmfx4bvsvk";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ perl ];
  propagatedBuildInputs = [ attr ];

  preConfigure = "cd libcap";

  makeFlags = "lib=lib prefix=$(out)";

  postInstall = ''
    mkdir -p "$dev/share/doc/${name}"
    cp ../License "$dev/share/doc/${name}/License"
  '';

  meta = {
    description = "Library for working with POSIX capabilities";
    platforms = stdenv.lib.platforms.linux;
  };
}
