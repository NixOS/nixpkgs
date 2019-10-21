{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig, fuse3 }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xzqj1ygd4s6zcy2xfqqxd4aps6r4r7yb92n64xlyzlfw4xqfpxa";
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
