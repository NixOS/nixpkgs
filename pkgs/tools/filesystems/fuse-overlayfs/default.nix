{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig, fuse3 }:

stdenv.mkDerivation rec {
  name = "fuse-overlayfs-${version}";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "fuse-overlayfs";
    rev = "v${version}";
    sha256 = "1cch2j397hydrhh62faqa663vas75qbmylqd06fk6nafasa3ri0l";
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
