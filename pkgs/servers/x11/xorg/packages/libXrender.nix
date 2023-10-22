{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXrender";
  version = "0.9.11";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXrender";
    rev = "refs/tags/libXrender-0.9.11";
    hash = "sha256-6CZyPsirqV6n/g7dCowL9V2DPx5CLXrkN3t+AiCgPSc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
