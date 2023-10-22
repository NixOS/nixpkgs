{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpthread-stubs";
  version = "0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "pthread-stubs";
    rev = "refs/tags/libpthread-stubs-0.5";
    hash = "sha256-VvqHHqZn3bx+Ok95QXhSQFvswQfygMPx5WomuuWJTzQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
