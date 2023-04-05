{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, fuse3, nixosTests }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BrZ+af5WmIEFC1NwpcVqxol4b4aFxj1wnvxDGx20SBA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ fuse3 ];

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma9e ] ++ teams.podman.members;
    platforms = platforms.linux;
    inherit (src.meta) homepage;
  };
}
