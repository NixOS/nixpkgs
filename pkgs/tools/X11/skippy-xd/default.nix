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
  version = "unstable-2015-03-01";
  src = fetchFromGitHub {
    owner = "richardgv";
    repo = "skippy-xd";
    rev = "397216ca67074c71314f5e9a6e3f1710ccabc29e";
    sha256 = "sha256-iP6g3iS1aPPkauBLHbgZH/l+TXbWyIJ2TmbrSiNTkn0=";
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
