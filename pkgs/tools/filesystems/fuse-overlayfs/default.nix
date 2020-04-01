{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config, fuse3 }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "10wsssf9mxgkgcqks3z02y9ya8xh4wd45lsb1jrvw31wmz9zpalc";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

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
