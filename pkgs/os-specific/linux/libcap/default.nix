{ stdenv, fetchurl, attr, perl }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "libcap-${version}";
  version = "2.22";
  
  src = fetchurl {
    url = "mirror://gentoo/distfiles/${name}.tar.bz2";
    sha256 = "03q50j6bg65cc501q87qh328ncav1i8qw2bjig99vxmmfx4bvsvk";
  };
  
  nativeBuildInputs = [ perl ];
  propagatedBuildInputs = [ attr ];

  preConfigure = "cd libcap";

  makeFlags = "lib=lib prefix=$(out)";

  passthru = {
    postinst = n : ''
      mkdir -p $out/share/doc/${n}
      cp ../License $out/share/doc/${n}/License
    '';
  };

  postInstall = passthru.postinst name;

  meta = {
    description = "Library for working with POSIX capabilities";
    platforms = stdenv.lib.platforms.linux;
  };
}
