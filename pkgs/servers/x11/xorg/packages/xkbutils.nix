{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkbutils";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xkbutils";
    rev = "refs/tags/xkbutils-1.0.5";
    hash = "sha256-S+lQULfYwMKNcB/iOmWIvF3XCkElXLB3ytM/hoxa9hQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
