{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmag";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xmag";
    rev = "refs/tags/xmag-1.0.7";
    hash = "sha256-JvAdtHNYOkC7lK31N9sbWTgPo7UGjjbSYL+InqTUhco=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
