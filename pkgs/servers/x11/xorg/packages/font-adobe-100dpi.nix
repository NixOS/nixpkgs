{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-adobe-100dpi";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "adobe-100dpi";
    rev = "refs/tags/font-adobe-100dpi-1.0.4";
    hash = "sha256-EiC6fo5YAxQ+nvM/+k/NB25sFBL938poxnwDtggK7XM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
