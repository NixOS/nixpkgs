{ lib
, stdenv
, fetchFromGitHub
, xorgproto
, libX11
, libXft
, libXcomposite
, libXdamage
, libXext
, libXinerama
, libjpeg
, giflib
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "skippy-xd";
  version = "0.7.2";
  src = fetchFromGitHub {
    owner = "felixfung";
    repo = "skippy-xd";
    rev = "e033b9ea80b5bbe922b05c64ed6ba0bf31c3acf6";
    hash = "sha256-DsoRxbAF0DitgxknJVHDWH7VL5hWMhwH9I6m1SyItMM=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorgproto
    libX11
    libXft
    libXcomposite
    libXdamage
    libXext
    libXinerama
    libjpeg
    giflib
  ];
  makeFlags = [ "PREFIX=$(out)" ];
  preInstall = ''
    sed -e "s@/etc/xdg@$out&@" -i Makefile
  '';
  meta = with lib; {
    description = "Expose-style compositing-based standalone window switcher";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
