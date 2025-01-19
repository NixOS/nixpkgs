{
  mkDerivation,
  lib,
  fetchFromGitLab,
  cmake,
  alsa-lib,
  udev,
  qtbase,
  qtsvg,
  qttools,
}:

mkDerivation rec {
  pname = "qastools";
  version = "0.23.0";

  src = fetchFromGitLab {
    owner = "sebholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "19hn64hnvryfmrkdg6rqyzahdbqf1s5y3dcca389jj6sdx93b3ip";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    alsa-lib
    udev
    qtbase
    qtsvg
    qttools
  ];

  meta = {
    description = "Collection of desktop applications for ALSA configuration";
    homepage = "https://gitlab.com/sebholt/qastools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = lib.platforms.linux;
  };
}
