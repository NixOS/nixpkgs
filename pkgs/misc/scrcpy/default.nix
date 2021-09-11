{ lib, stdenv, fetchurl, fetchFromGitHub, makeWrapper
, meson
, ninja
, pkg-config
, fetchpatch

, platform-tools
, ffmpeg
, SDL2
}:

let
  version = "1.19";
  prebuilt_server = fetchurl {
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}";
    sha256 = "sha256-h2+TIhguaqxqWNsTNPQiWFXvOhfq68gKq2YB2dHsuGc=";
  };
in
stdenv.mkDerivation rec {
  pname = "scrcpy";
  inherit version;

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IR4FTbVtHp9rRm0U4d1zkl0u+oR5FeElJ91NIspSKWg=";
  };

  # postPatch:
  #   screen.c: When run without a hardware accelerator, this allows the command to continue working rather than failing unexpectedly.
  #   This can happen when running on non-NixOS because then scrcpy seems to have a hard time using the host OpenGL-supporting hardware.
  #   It would be better to fix the OpenGL problem, but that seems much more intrusive.
  postPatch = ''
    substituteInPlace app/src/screen.c \
      --replace "SDL_RENDERER_ACCELERATED" "SDL_RENDERER_ACCELERATED || SDL_RENDERER_SOFTWARE"
  '';

  nativeBuildInputs = [ makeWrapper meson ninja pkg-config ];

  buildInputs = [ ffmpeg SDL2 ];

  # Manually install the server jar to prevent Meson from "fixing" it
  preConfigure = ''
    echo -n > server/meson.build
  '';

  mesonFlags = [ "-Doverride_server_path=${prebuilt_server}" ];
  postInstall = ''
    mkdir -p "$out/share/scrcpy"
    ln -s "${prebuilt_server}" "$out/share/scrcpy/scrcpy-server"

    # runtime dep on `adb` to push the server
    wrapProgram "$out/bin/scrcpy" --prefix PATH : "${platform-tools}/bin"
  '';

  meta = with lib; {
    description = "Display and control Android devices over USB or TCP/IP";
    homepage = "https://github.com/Genymobile/scrcpy";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ deltaevo lukeadams msfjarvis ];
  };
}
