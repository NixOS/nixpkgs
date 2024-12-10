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
    sha256 = "sha256-gPFElAixiDTTwcl2XKM7MbTkpRrg8ToO5K7H8kz3DHk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://gitlab.com/interception/linux/plugins/caps2esc";
    description = "Transforming the most useless key ever into the most useful one";
    mainProgram = "caps2esc";
    license = licenses.mit;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.linux;
  };
}
