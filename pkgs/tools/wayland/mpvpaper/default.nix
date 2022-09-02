{ stdenv
, lib
, meson
, cmake
, ninja
, wlroots
, wayland
, wayland-protocols
, egl-wayland
, glew-egl
, mpv
, pkg-config
, fetchFromGitHub
, makeWrapper
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "mpvpaper";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "GhostNaN";
    repo = pname;
    rev = version;
    sha256 = "sha256-1+noph6iXM5OSNMFQyta/ttGyZQ6F7bWDQi8W190G5E=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    wlroots
    wayland
    wayland-protocols
    egl-wayland
    glew-egl
    mpv
  ];

  preInstall = ''
    mv ../mpvpaper.man ../mpvpaper.1
  '';

  postInstall = ''
    wrapProgram $out/bin/mpvpaper \
      --prefix PATH : ${lib.makeBinPath [ mpv ]}

    installManPage ../mpvpaper.1
  '';

  meta = with lib; {
    description = "A video wallpaper program for wlroots based wayland compositors";
    homepage = "https://github.com/GhostNaN/mpvpaper";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "mpvpaper";
    maintainers = with maintainers; [ atila ];
  };
}
