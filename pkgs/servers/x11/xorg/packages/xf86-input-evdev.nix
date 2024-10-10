{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-evdev";
  version = "2.10.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-evdev";
    rev = "refs/tags/xf86-input-evdev-2.10.6";
    hash = "sha256-j+H6mQqkx5hX9aC7f4uvwvnzxoU/CQBUrHtJOi8qPac=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
