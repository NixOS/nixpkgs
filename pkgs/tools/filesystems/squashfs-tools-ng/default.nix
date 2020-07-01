{ stdenv, lib, fetchurl, doxygen, graphviz, perl, pkgconfig
, lz4, lzo, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "0.9.1";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "1ilxkrqbpb5whv7xfwfvph76jwyjzf988njjpyyr99h6jv2r77q1";
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
