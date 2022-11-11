{ lib
, stdenv
, fetchFromGitHub
, meson
, pkg-config
, ninja
, wayland-scanner
, libdrm
, wayland
, wayland-protocols
, wl-clipboard
, libxkbcommon
, cmake
, libressl
}:
stdenv.mkDerivation rec {
  pname = "waynergy";
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "r-c-f";
    repo = "waynergy";
    rev = "v${version}";
    hash = "sha256-eTY7tktUmoTZO3w9uP1P8cIz0mmFiWm5YFGVAS6JwwE=";
  };

  depsBuildBuild = [ pkg-config ];
  buildInputs = [ libdrm wayland wayland-protocols wl-clipboard libxkbcommon cmake libressl ];
  nativeBuildInputs = [ meson ninja ];

  postPatch = ''
    substituteInPlace waynergy.desktop --replace "Exec=/usr/bin/waynergy" "Exec=$out/bin/waynergy"
  '';

  meta = with lib; {
    description = "A synergy client for Wayland compositors";
    longDescription = ''
      A synergy client for Wayland compositors
    '';
    homepage = "https://github.com/r-c-f/waynergy";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ maxhero pedrohlc ];
  };
}
