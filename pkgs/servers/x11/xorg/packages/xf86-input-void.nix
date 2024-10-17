{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-void";
  version = "1.4.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-void";
    rev = "refs/tags/xf86-input-void-1.4.2";
    hash = "sha256-R2c+FUBJQ9GfMcZ9NKSgT0lfOkqiCKrA+lFVu8l6e10=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
