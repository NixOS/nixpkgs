{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig, fuse3 }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jgv5h28pl6ms2iivar4ccq6jvyphqrlbldr1pch55l8jvzfplfl";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ fuse3 ];

  meta = with lib; {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma9e ];
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
