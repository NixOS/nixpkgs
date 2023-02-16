{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, wrapGAppsHook4
, gtk4
, qrencode
}:

stdenv.mkDerivation rec {
  pname = "iwgtk";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "j-lentz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/Nxti4PfYVLnIiBgtAuR3KGI8dULszuSdTp+2DzBfbs=";
  };

  # patch systemd service to pass necessary environments and use absolute paths
  patches = [ ./systemd-service.patch ];

  nativeBuildInputs = [ meson ninja pkg-config scdoc wrapGAppsHook4 ];

  buildInputs = [ gtk4 qrencode ];

  postInstall = ''
    substituteInPlace $out/lib/systemd/user/iwgtk.service --subst-var out
  '';

  meta = with lib; {
    description = "Lightweight, graphical wifi management utility for Linux";
    homepage = "https://github.com/j-lentz/iwgtk";
    changelog = "https://github.com/j-lentz/iwgtk/blob/v${version}/CHANGELOG";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda ];
  };
}
