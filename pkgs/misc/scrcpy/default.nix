{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, makeWrapper
, meson
, ninja
, pkg-config
, runtimeShell
, installShellFiles

, android-tools
, ffmpeg
, libusb1
, SDL2
}:

let
  version = "2.3.1";
  prebuilt_server = fetchurl {
    name = "scrcpy-server";
    inherit version;
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}";
    hash = "sha256-9oFIIvwwinpTLyU0hckDgYPGKWpsXfRwqeODtPjnYFs=";
  };
in
stdenv.mkDerivation rec {
  pname = "scrcpy";
  inherit version;

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = "scrcpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-RM29WjzsYnn26x/Xr2RKp0p87/v+Jl8skEcAwxhZEtU=";
  };

  #   display.c: When run without a hardware accelerator, this allows the command to continue working rather than failing unexpectedly.
  #   This can happen when running on non-NixOS because then scrcpy seems to have a hard time using the host OpenGL-supporting hardware.
  #   It would be better to fix the OpenGL problem, but that seems much more intrusive.
  postPatch = ''
    substituteInPlace app/src/display.c \
      --replace "SDL_RENDERER_ACCELERATED" "SDL_RENDERER_ACCELERATED || SDL_RENDERER_SOFTWARE"
  '';

  nativeBuildInputs = [ makeWrapper meson ninja pkg-config installShellFiles ];

  buildInputs = [ ffmpeg SDL2 libusb1 ];

  # Manually install the server jar to prevent Meson from "fixing" it
  preConfigure = ''
    echo -n > server/meson.build
  '';

  postInstall = ''
    mkdir -p "$out/share/scrcpy"
    ln -s "${prebuilt_server}" "$out/share/scrcpy/scrcpy-server"

    # runtime dep on `adb` to push the server
    wrapProgram "$out/bin/scrcpy" --prefix PATH : "${android-tools}/bin"
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/share/applications/scrcpy-console.desktop \
      --replace "/bin/bash" "${runtimeShell}"
  '';

  meta = with lib; {
    description = "Display and control Android devices over USB or TCP/IP";
    homepage = "https://github.com/Genymobile/scrcpy";
    changelog = "https://github.com/Genymobile/scrcpy/releases/tag/v${version}";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # server
    ];
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ deltaevo msfjarvis ];
    mainProgram = "scrcpy";
  };
}
