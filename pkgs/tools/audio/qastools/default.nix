{ mkDerivation, lib, fetchFromGitLab, cmake, alsaLib, udev, qtbase, qtsvg, qttools }:

mkDerivation rec {
  pname = "qastools";
  version = "0.22.0";

  src = fetchFromGitLab {
    owner = "sebholt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0px4fcn8dagivq5fyi5gy84yj86f6x0lk805mc4ry58d0wsbn68v";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ alsaLib udev qtbase qtsvg qttools ];

  meta = with lib; {
    description = "Collection of desktop applications for ALSA configuration";
    homepage = "https://gitlab.com/sebholt/qastools";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
