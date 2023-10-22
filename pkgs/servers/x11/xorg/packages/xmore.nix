{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmore";
  version = "1.0.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xmore";
    rev = "refs/tags/xmore-1.0.3";
    hash = "sha256-ni16E9dKmM4h4ePnesXjXeB0A+sGwpBsngvlsT8u3bE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
