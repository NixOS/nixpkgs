{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpciaccess";
  version = "0.17";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libpciaccess";
    rev = "refs/tags/libpciaccess-0.17";
    hash = "sha256-saLijNTgAywWX1EZw9Oic3QN5+tBO/d0uFvapgmR6lw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
