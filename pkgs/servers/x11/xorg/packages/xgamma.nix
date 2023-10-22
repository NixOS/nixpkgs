{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xgamma";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xgamma";
    rev = "refs/tags/xgamma-1.0.7";
    hash = "sha256-KlwPvvrtfalvAIjG7Buz1MjpZmEf/yvieCLQOqodhuc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
