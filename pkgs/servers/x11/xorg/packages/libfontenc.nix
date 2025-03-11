{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfontenc";
  version = "1.1.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libfontenc";
    rev = "refs/tags/libfontenc-1.1.7";
    hash = "sha256-olZwO5MhT+JJoWXeZMukXPFA+xb4cyoE7GfSf15MKE0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
