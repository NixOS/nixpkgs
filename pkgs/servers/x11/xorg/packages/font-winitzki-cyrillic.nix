{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-winitzki-cyrillic";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "winitzki-cyrillic";
    rev = "refs/tags/font-winitzki-cyrillic-1.0.4";
    hash = "sha256-KHMT2XBrTwwvW8Dx/RdP3yPrqeqnkk5y9B+dXqZ0+rA=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
