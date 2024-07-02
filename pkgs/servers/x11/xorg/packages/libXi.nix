{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXi";
  version = "1.8.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXi";
    rev = "refs/tags/libXi-1.8.1";
    hash = "sha256-kCdtHLN5bbcnybgJNuEDexamBXeFiU8a8vLc23tLE9c=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
