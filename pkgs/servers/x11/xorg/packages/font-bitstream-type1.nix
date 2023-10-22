{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bitstream-type1";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bitstream-type1";
    rev = "refs/tags/font-bitstream-type1-1.0.4";
    hash = "sha256-Jp3aEoQHpLpWbnoUzc3ZBOQoqIdlK6E8//1dPRL26A8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
