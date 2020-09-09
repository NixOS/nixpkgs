{ stdenv, lib, fetchurl, doxygen, graphviz, perl, pkgconfig
, lz4, lzo, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "1.0.1";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "120x2hlbhpm90bzxz70z764552ffrjpidmp1y6gafx70zp0hrks4";
  };

  nativeBuildInputs = [ doxygen graphviz pkgconfig perl ];
  buildInputs = [ zlib xz lz4 lzo zstd ];

  meta = with lib; {
    homepage = "https://github.com/AgentD/squashfs-tools-ng";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
