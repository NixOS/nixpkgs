{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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
  patches = [
    (fetchpatch {
      url = "https://gitlab.com/interception/linux/plugins/caps2esc/-/commit/47ea8022df47b23d5d9603f9fe71b3715e954e4c.patch";
      sha256 = "sha256-lB+pDwmFWW1fpjOPC6GLpxvrs87crDCNk1s9KnfrDD4=";
    })
  ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://gitlab.com/interception/linux/plugins/caps2esc";
    description = "Transforming the most useless key ever into the most useful one";
    mainProgram = "caps2esc";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
