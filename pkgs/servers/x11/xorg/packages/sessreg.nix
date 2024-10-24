{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sessreg";
  version = "1.1.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "sessreg";
    rev = "refs/tags/sessreg-1.1.3";
    hash = "sha256-a4Q6YC66m9s5KmwWujYyef1RaWDPdd6Zkh/WrLRDXcU=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
