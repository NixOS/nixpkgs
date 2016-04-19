{ stdenv, fetchurl, attr, perl }:

stdenv.mkDerivation rec {
  name = "libcap-${version}";
  version = "2.25";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/security/linux-privs/libcap2/${name}.tar.xz";
    sha256 = "0qjiqc5pknaal57453nxcbz3mn1r4hkyywam41wfcglq3v2qlg39";
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
