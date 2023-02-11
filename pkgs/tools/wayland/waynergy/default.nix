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
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "r-c-f";
    repo = "waynergy";
    rev = "v${version}";
    hash = "sha256-pk1U3svy9r7O9ivFjBNXsaOmgc+nv2QTuwwHejB7B4Q=";
  };

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja ];
  buildInputs = [ libdrm wayland wayland-protocols wl-clipboard libxkbcommon libressl ];

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
