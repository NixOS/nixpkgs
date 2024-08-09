{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXinerama";
  version = "1.1.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXinerama";
    rev = "refs/tags/libXinerama-1.1.5";
    hash = "sha256-4TdrntP9uQNruVIYy7vrvA8MEPu8bSbGKySvVQP6kHc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
