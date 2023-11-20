{ stdenv
, lib
, meson
, ninja
, wlroots
, wayland
, wayland-protocols
, wayland-scanner
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
  version = "1.3";

  src = fetchFromGitHub {
    owner = "GhostNaN";
    repo = pname;
    rev = version;
    sha256 = "sha256-0LjIwOY2hBUb0nziD3HLP2Ek5+8v3ntssRFD9eQgWkc=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    installShellFiles
    wayland-scanner
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
