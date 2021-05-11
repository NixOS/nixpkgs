{ stdenv, lib, fetchurl, doxygen, graphviz, perl, pkg-config
, bzip2, lz4, lzo, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "1.1.1";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "07c8vpzgwvqr9ycww1769ya40cf077c6igdg1b4akwszz2nw0bxq";
  };

  nativeBuildInputs = [ doxygen graphviz pkg-config perl ];
  buildInputs = [ bzip2 zlib xz lz4 lzo zstd ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/AgentD/squashfs-tools-ng";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;

    # TODO: Remove once nixpkgs uses newer SDKs that supports '*at' functions.
    # Probably macOS SDK 10.13 or later. Check the current version in
    # ../../../../os-specific/darwin/apple-sdk/default.nix
    #
    # From the build logs:
    #
    # > Undefined symbols for architecture x86_64:
    # >   "_utimensat", referenced from:
    # >       _set_attribs in rdsquashfs-restore_fstree.o
    # > ld: symbol(s) not found for architecture x86_64
    broken = stdenv.isDarwin;
  };
}
