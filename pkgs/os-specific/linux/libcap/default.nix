{ stdenv, fetchurl, attr, perl }:

stdenv.mkDerivation rec {
  name = "libcap-${version}";
  version = "2.24";
  
  src = fetchurl {
    url = "mirror://kernel/linux/libs/security/linux-privs/libcap2/${name}.tar.xz";
    sha256 = "0rbc9qbqs5bp9am9s9g83wxj5k4ixps2agy9dxr1v1fwg27mdr6f";
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
