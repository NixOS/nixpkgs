{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util-cursor";
  version = "0.1.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcb-cursor";
    rev = "refs/tags/xcb-util-cursor-0.1.4";
    hash = "sha256-USi7aqq0wgUwDj0pSza1iv41WEaSoakZcbbGAis/x64=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
