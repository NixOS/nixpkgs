{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig, fuse3 }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "03sdnnq0x44jlwf41snrrma4hxdiixmhynw35gjhm84slpljnngp";
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
