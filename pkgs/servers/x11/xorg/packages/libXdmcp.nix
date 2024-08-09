{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXdmcp";
  version = "1.1.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXdmcp";
    rev = "refs/tags/libXdmcp-1.1.4";
    hash = "sha256-Qk8NcNQ6tRqhJM9MKi2wFGagxpLBSZPc+vQnsY7HCYI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
