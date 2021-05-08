{ stdenv, lib, fetchurl, doxygen, graphviz, perl, pkg-config
, lz4, lzo, xz, zlib, zstd
}:

stdenv.mkDerivation rec {
  pname = "squashfs-tools-ng";
  version = "1.1.0";

  src = fetchurl {
    url = "https://infraroot.at/pub/squashfs/squashfs-tools-ng-${version}.tar.xz";
    sha256 = "1swsw5j8rrjxdxsfyd446f6g8f0k3mwg15baivi953i69c9981qi";
  };

  nativeBuildInputs = [ doxygen graphviz pkg-config perl ];
  buildInputs = [ zlib xz lz4 lzo zstd ];

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
