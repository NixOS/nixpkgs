{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-schumacher-misc";
  version = "1.1.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "schumacher-misc";
    rev = "refs/tags/font-schumacher-misc-1.1.3";
    hash = "sha256-RbQ7UjVNPvECDrVPMoaKMtFn+70lkYsxuNa8Tf+Irgo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
