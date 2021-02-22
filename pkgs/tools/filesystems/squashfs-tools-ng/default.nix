{ stdenv, lib, fetchurl, doxygen, graphviz, perl, pkg-config
, lz4, lzo, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "1.0.4";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "04zvpws1nk3r2kr1k5in9di9fhn4zzciyndgnxnijmhiqpyrx072";
  };

  nativeBuildInputs = [ doxygen graphviz pkg-config perl ];
  buildInputs = [ zlib xz lz4 lzo zstd ];

  meta = with lib; {
    homepage = "https://github.com/AgentD/squashfs-tools-ng";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
