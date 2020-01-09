{ stdenv, lib, fetchurl, fetchpatch, autoreconfHook, doxygen, graphviz, perl
, pkgconfig, lz4, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "0.7";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "01yn621dnsfhrah3qj1xh6ynag7r3nvihc510sa5frapkyg9nw8n";
  };

  patches = lib.optional (!stdenv.isLinux) ./0001-Fix-build-on-BSD-systems.patch;

  nativeBuildInputs = [ doxygen graphviz pkgconfig perl ]
                      ++ lib.optional (!stdenv.isLinux) autoreconfHook;
  buildInputs = [ zlib xz lz4 zstd ];

  meta = with lib; {
    homepage = https://github.com/AgentD/squashfs-tools-ng;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
  };
}
