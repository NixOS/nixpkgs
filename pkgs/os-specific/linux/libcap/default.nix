{ stdenv, fetchurl, attr, perl }:

stdenv.mkDerivation rec {
  name = "libcap-${version}";
  version = "2.24";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/security/linux-privs/libcap2/${name}.tar.xz";
    sha256 = "0rbc9qbqs5bp9am9s9g83wxj5k4ixps2agy9dxr1v1fwg27mdr6f";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ perl ];
  propagatedBuildInputs = [ attr ];

  preConfigure = "cd libcap";

  makeFlags = "lib=lib prefix=$(out)";

  postInstall = ''
    rm "$out"/lib/*.a
    mkdir -p "$dev/share/doc/${name}"
    cp ../License "$dev/share/doc/${name}/License"
  '';

  meta = {
    description = "Library for working with POSIX capabilities";
    platforms = stdenv.lib.platforms.linux;
  };
}
