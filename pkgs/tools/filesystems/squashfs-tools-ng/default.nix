{ stdenv, lib, fetchurl, doxygen, graphviz, perl, pkgconfig
, lz4, lzo, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "0.9";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "1jx6bga0k07cckpv0yk77kwql7rjiicf9wkbadc8yqhp463xn90q";
  };

  nativeBuildInputs = [ doxygen graphviz pkgconfig perl ];
  buildInputs = [ zlib xz lz4 lzo zstd ];

  meta = with lib; {
    homepage = https://github.com/AgentD/squashfs-tools-ng;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
