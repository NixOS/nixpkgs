{ stdenv, fetchFromGitHub, autoreconfHook, pkg-config, fuse3 }:

stdenv.mkDerivation rec {
  pname = "fuse-overlayfs";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "0h1ay2l7zyiqplh8whanw68mcfri79lc03wjjrhqji5ddwznv6fa";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ fuse3 ];

  meta = with stdenv.lib; {
    description = "FUSE implementation for overlayfs";
    longDescription = "An implementation of overlay+shiftfs in FUSE for rootless containers.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma9e ] ++ teams.podman.members;
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
