{ lib, stdenv
, fetchFromGitHub
, PDCurses, SDL, SDL_mixer, libyamlcpp
}:

stdenv.mkDerivation rec {
  name = "ASCIIpOrtal";
  version = "1.3-beta8";

  src = fetchFromGitHub {
    owner = "cymonsgames";
    repo = name;
    rev = "v${version}";
    sha256 = "sha256-OXTA9/PoCGTPKwPw0b/yGgKyid/vdpTtF2nvZlGfmFo=";
  };

  buildInputs = [ SDL_mixer libyamlcpp SDL PDCurses.sdl1 PDCurses.x11];

  postPatch = ''
    # change where to look for assets
    substituteInPlace src/ap_filemgr.cpp \
      --replace "/usr/share/asciiportal" "$out/share/asciiportal"

    # optimization causes segmentation fault
    substituteInPlace Makefile.common \
      --replace "-O2" "-O0"

    # change install location
    substituteInPlace Makefile.default \
      --replace '$(DESTDIR)/usr' '$(DESTDIR)'
  '';

  makeFlags = [ "DESTDIR=$(out)" ];
  buildFlags = [ "linux" ];

  meta = with lib; {
    description = "It's like portal, but in ASCII. And 2D. Sweet look-through mechanic, tho";
    homepage = "https://github.com/cymonsgames/ASCIIpOrtal";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hqurve ];
  };
}
