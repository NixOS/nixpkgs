{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-amdgpu";
  version = "23.0.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-amdgpu";
    rev = "refs/tags/xf86-video-amdgpu-23.0.0";
    hash = "sha256-3hFEhgwTwoahx0mw6fCMasIJINkgYiiXjv8fbxgDmFE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
