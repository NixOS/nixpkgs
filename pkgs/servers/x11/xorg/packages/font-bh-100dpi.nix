{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-100dpi";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bh-100dpi";
    rev = "refs/tags/font-bh-100dpi-1.0.4";
    hash = "sha256-akc5oHlD0xln+xVK4mQnv29aXb6IHuE+auNESJ4tN8w=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
