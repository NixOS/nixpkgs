{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bitstream-speedo";
  version = "1.0.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bitstream-speedo";
    rev = "refs/tags/font-bitstream-speedo-1.0.2";
    hash = "sha256-bvIDqOewz0xjZCAKla+5D62e9QBxOHVZ9Qu88nYAMjc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
