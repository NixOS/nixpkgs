{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xload";
  version = "1.1.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xload";
    rev = "refs/tags/xload-1.1.4";
    hash = "sha256-L59b9k7PxkVA0Yw0jd3QOsrvsqlIMPto/4GcjLTUkPs=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
