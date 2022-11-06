{ lib
, nixosTests
, stdenv
, cryptsetup
, dejavu_fonts
, fetchFromGitLab
, meson
, ninja
, pkg-config
, scdoc
, SDL2
, SDL2_ttf
}:
stdenv.mkDerivation rec {
  pname = "osk-sdl";
  version = "0.67.1";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "postmarketOS";
    repo = pname;
    rev = version;
    hash = "sha256-IgtSGxMKqzm8iIILnJ1ZEXSW0R4k6Ffm734XGH+P58w=";
  };

  postPatch = ''
    substituteInPlace osk.conf \
      --replace /usr/share/fonts/ttf-dejavu/DejaVuSans.ttf ${dejavu_fonts}/share/fonts/truetype/DejaVuSans.ttf
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    cryptsetup
    dejavu_fonts
    SDL2
    SDL2_ttf
  ];

  passthru.tests = nixosTests.systemd-initrd-luks-osk-sdl;

  meta = with lib; {
    description = "SDL2 On-screen Keyboard";
    homepage = "https://gitlab.com/postmarketOS/osk-sdl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tomfitzhenry ];
    platforms = platforms.linux;
  };
}
