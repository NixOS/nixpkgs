{ pkgs, lib, autoreconfHook, pkgconfig, fuse3 }:

let
  version = "0.2";
in
  pkgs.stdenv.mkDerivation {
    name = "fuse-overlayfs-${version}";

    src = pkgs.fetchFromGitHub {
      owner = "containers";
      repo = "fuse-overlayfs";
      rev = "1e2b65baa2f75eea0e4bab90b5ac81dd8471256c";
      sha256 = "0a9ix8rqjs5r28jsriyiv4yq7iilmv69x05kf23s1ihzrvrfkl08";
    };

    nativeBuildInputs = [ autoreconfHook pkgconfig ];
    buildInputs = [ fuse3 ];

    meta = with lib; {
      homepage = https://github.com/containers/fuse-overlayfs;
      description = "FUSE implementation for overlayfs";
      longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
      license = licenses.gpl3;
      platforms = platforms.unix;
      maintainers = [ maintainers.ma9e ];
    };
  }
