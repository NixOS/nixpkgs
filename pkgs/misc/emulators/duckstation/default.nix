{ lib, mkDerivation, fetchFromGitHub, cmake, pkg-config, SDL2, qtbase
, wrapQtAppsHook, qttools, ninja, gtk3 }:
mkDerivation rec {
  pname = "duckstation";
  version = "unstable-2020-12-29";

  src = fetchFromGitHub {
    owner = "stenzek";
    repo = pname;
    rev = "f8dcfabc44ff8391b2d41eab2e883dc8f21a88b7";
    sha256 = "0v6w4di4yj1hbxpqqrcw8rbfjg18g9kla8mnb3b5zgv7i4dyzykw";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook qttools ];

  buildInputs = [ SDL2 qtbase gtk3 pkg-config ];

  installPhase = ''
    mkdir -p $out/
    mv bin $out/
  '';

  # TODO:
  # - vulkan graphics backend (OpenGL works).
  # - default sound backend (cubeb) does not work, but SDL does.
  meta = with lib; {
    description =
      "PlayStation 1 emulator focusing on playability, speed and long-term maintainability";
    homepage = "https://github.com/stenzek/duckstation";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.guibou ];
  };
}
