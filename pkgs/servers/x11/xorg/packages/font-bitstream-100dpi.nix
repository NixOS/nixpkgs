{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bitstream-100dpi";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bitstream-100dpi";
    rev = "refs/tags/font-bitstream-100dpi-1.0.4";
    hash = "sha256-NfqH78Zh84BmLM7duzNZt4tpgW5Ge9gUXdxGnotFjFs=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
