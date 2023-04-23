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
  version = "0.6.0";
  src = fetchFromGitHub {
    owner = "dreamcat4";
    repo = "skippy-xd";
    rev = "d0557c3144fc67568a49d7207efef89c1d5777a0";
    sha256 = "sha256-dnoPUPCvuR/HhqIz1WAsmWL/CkfTf11YEkbrkVWM4dc=";
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
