{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig, fuse3 }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qjkzpxv7zy9i6lvcrn8yp8dfsqak6c7ffx8g0xfavdx7am458ns";
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
