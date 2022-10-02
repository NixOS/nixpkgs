{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, wrapGAppsHook
, gtk4
, qrencode
}:

stdenv.mkDerivation rec {
  pname = "iwgtk";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "j-lentz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-89rzDxalZtQkwAKS6hKPVY87kOWPySwDeZrPs2rGs/k=";
  };

  # patch systemd service to pass necessary environments and use absolute paths
  patches = [ ./systemd-service.patch ];

  nativeBuildInputs = [ meson ninja pkg-config scdoc wrapGAppsHook ];

  buildInputs = [ gtk4 qrencode ];

  postInstall = ''
    mv $out/share/lib/systemd $out/share
    rmdir $out/share/lib
    substituteInPlace $out/share/systemd/user/iwgtk.service --subst-var out
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
