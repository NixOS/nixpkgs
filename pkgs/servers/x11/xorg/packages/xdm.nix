{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdm";
  version = "1.1.14";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xdm";
    rev = "refs/tags/xdm-1.1.14";
    hash = "sha256-BPUXGGfBJYYbyEdgqQ6NNV9oL8dqVI6kRapLP2U0Weg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
