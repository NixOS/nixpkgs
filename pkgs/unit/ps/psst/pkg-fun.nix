{ lib, fetchFromGitHub, rustPlatform, alsa-lib, atk, cairo, dbus, gdk-pixbuf, glib, gtk3, pango, pkg-config, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "Psst";
    exec = "psst-gui";
    comment = "Fast and multi-platform Spotify client with native GUI";
    desktopName = "Psst";
    type = "Application";
    categories = [ "Audio" "AudioVideo" ];
    icon = "psst";
    terminal = false;
  };

in
rustPlatform.buildRustPackage rec {
  pname = "psst";
  version = "unstable-2022-10-13";

  src = fetchFromGitHub {
    owner = "jpochyla";
    repo = pname;
    rev = "d70ed8104533dc15bc36b989ba8428872c9b578f";
    hash = "sha256-ZKhHN0ruLb6ZVKkrKv/YawRsVop6SP1QF/nrtkmA8P8=";
  };

  cargoSha256 = "sha256-TDxoRWQAzrgPElEEDNYkk3XX2i+LnNLMuY/J3pb3Xlk=";
  # specify the subdirectory of the binary crate to build from the workspace
  buildAndTestSubdir = "psst-gui";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  postInstall = ''
    install -Dm444 psst-gui/assets/logo_512.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*
  '';

  meta = with lib; {
    description = "Fast and multi-platform Spotify client with native GUI";
    homepage = "https://github.com/jpochyla/psst";
    license = licenses.mit;
    maintainers = with maintainers; [ vbrandl peterhoeg ];
  };
}
