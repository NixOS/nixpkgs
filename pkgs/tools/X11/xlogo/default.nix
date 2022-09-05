{ lib
, stdenv
, fetchFromGitLab
, xorg
, autoreconfHook
, pkg-config
, xorg-autoconf
}:

stdenv.mkDerivation rec {
  pname = "xlogo";
  version = "1.0.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xlogo";
    rev = "refs/tags/xlogo-${version}";
    hash = "sha256-AyNFzRZtbCKkGacBCaGZZkLRTAGq5TrA2OXGqwoKq24=";
  };

  nativeBuildInputs = [ xorg-autoconf autoreconfHook pkg-config ];

  configureFlags = [ "--with-appdefaultdir=$out/share/X11/app-defaults" ];

  buildInputs = [ xorg.libX11 xorg.libXext xorg.libSM xorg.libXmu xorg.libXaw xorg.libXt ];

  meta = with lib; {
    description = "X Window System logo display demo";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xlogo";
    maintainers = with maintainers; [ raboof ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
