{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xinput";
  version = "1.6.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xinput";
    rev = "refs/tags/xinput-1.6.4";
    hash = "sha256-EsSytLzwAHMwseW4pD/c+/J1MaCWPsE7RPoMIwT96yk=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
