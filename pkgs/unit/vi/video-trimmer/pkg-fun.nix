{ stdenv
, lib
, fetchFromGitLab
, rustPlatform
, pkg-config
, meson
, wrapGAppsHook4
, desktop-file-utils
, blueprint-compiler
, ninja
, gtk4
, libadwaita
, gst_all_1
, ffmpeg-full
}:

stdenv.mkDerivation rec {
  pname = "video-trimmer";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "YaLTeR";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0zhQoxzU1GikYP5OwqMl34RsnefJtdZox5EuTqOFnas=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-kH9AfEskh7TTXF+PZwOZNWVJmnEeMJrSEEuDGyP5A5o=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    wrapGAppsHook4
    desktop-file-utils
    blueprint-compiler
    ninja
    # Present here in addition to buildInputs, because meson runs
    # `gtk4-update-icon-cache` during installPhase, thanks to:
    # https://gitlab.gnome.org/YaLTeR/video-trimmer/-/merge_requests/12
    gtk4
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good # for scaletempo and webm
    gst_all_1.gst-plugins-bad
  ];

  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ffmpeg-full ]}"
    )
  '';

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/YaLTeR/video-trimmer";
    description = "Trim videos quickly";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
