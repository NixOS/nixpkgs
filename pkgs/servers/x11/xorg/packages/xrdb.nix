{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrdb";
  version = "1.2.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xrdb";
    rev = "refs/tags/xrdb-1.2.2";
    hash = "sha256-XCi/E6tVaLYGRsMWJalCl1J8VIT4xV6KFuo+K//LQGY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
