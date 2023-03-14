{ stdenv, lib, fetchurl, doxygen, graphviz, perl, pkg-config
, bzip2, lz4, lzo, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "1.2.0";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "sha256-1zYHYJXVhJdWQKeM0VVM4VzL3r3XPXebfR7IAEgyt+c=";
  };

  nativeBuildInputs = [ doxygen graphviz pkg-config perl ];
  buildInputs = [ bzip2 zlib xz lz4 lzo zstd ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/AgentD/squashfs-tools-ng";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
  };
}
