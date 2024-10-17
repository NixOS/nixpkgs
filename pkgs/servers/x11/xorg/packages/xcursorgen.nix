{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcursorgen";
  version = "1.0.8";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xcursorgen";
    rev = "refs/tags/xcursorgen-1.0.8";
    hash = "sha256-gYk/s/DF2AVI9bDCeDGKm51XxqNUl8SjUVvu2aR5jI8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
