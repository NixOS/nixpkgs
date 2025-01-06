{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "caps2esc";
  version = "0.3.2";

  src = fetchFromGitLab {
    group = "interception";
    owner = "linux/plugins";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gPFElAixiDTTwcl2XKM7MbTkpRrg8ToO5K7H8kz3DHk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://gitlab.com/interception/linux/plugins/caps2esc";
    description = "Transforming the most useless key ever into the most useful one";
    mainProgram = "caps2esc";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vyp ];
    platforms = lib.platforms.linux;
  };
}
