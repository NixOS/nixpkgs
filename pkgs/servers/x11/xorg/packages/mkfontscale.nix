{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mkfontscale";
  version = "1.2.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "mkfontscale";
    rev = "refs/tags/mkfontscale-1.2.2";
    hash = "sha256-wAwE4TenKuKHsCvoQVx7SLSn2c84DF9fKJpmCKuCyOo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
