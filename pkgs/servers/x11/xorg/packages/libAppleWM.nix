{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libAppleWM";
  version = "1.4.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libAppleWM";
    rev = "refs/tags/libAppleWM-1.4.1";
    hash = "sha256-7Ixr76UBfPiClGHzYu/zQjtgQQSiwRnzTZpc/vfsN7k=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
