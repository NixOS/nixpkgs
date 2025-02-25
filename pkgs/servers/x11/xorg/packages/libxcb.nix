{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb";
  version = "1.16";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcb";
    rev = "refs/tags/libxcb-1.16";
    hash = "sha256-khHvIFx53Hm2lfEpW8n1u8Src5LHJxyD3yf69A2jBJo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
