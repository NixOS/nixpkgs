{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util-renderutil";
  version = "0.3.10";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcb-render-util";
    rev = "refs/tags/xcb-util-renderutil-0.3.10";
    hash = "sha256-+QEQBkUVpVaYFKr6aN1VbkZj7wQHIGl4q6bh6l/Jo8I=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
