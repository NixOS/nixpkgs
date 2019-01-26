{ stdenv, fetchurl, fetchFromGitHub, makeWrapper
, meson
, ninja
, pkgconfig

, platform-tools
, ffmpeg
, SDL2
}:

let
  version = "1.5";
  prebuilt_server = fetchurl {
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}-fixversion/scrcpy-server-v${version}.jar";
    sha256 = "1pi47khfrs9pygs32l9rj8l927z0sdm8bhkrzzkk6ki9c1psnynr";
  };
in
stdenv.mkDerivation rec {
  name = "scrcpy-${version}";
  inherit version;
  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = "scrcpy";
    rev = "v${version}-fixversion";
    sha256 = "0magmc44pahw1f4jhzkhjlfc31mk3qq43hzn9513idcl4kh4sb8i";
  };

  # postPatch:
  #   screen.c: When run without a hardware accelerator, this allows the command to continue working rather than failing unexpectedly.
  #   This can happen when running on non-NixOS because then scrcpy seems to have a hard time using the host OpenGL-supporting hardware.
  #   It would be better to fix the OpenGL problem, but that seems much more intrusive.
  #
  #   command.c: When copying over the prebuilt binary to mobile, it also copies the permissions of the nix store, and thus it cannot delete normally.
  postPatch = ''
    substituteInPlace app/src/screen.c \
      --replace "SDL_RENDERER_ACCELERATED" "SDL_RENDERER_ACCELERATED || SDL_RENDERER_SOFTWARE"
    substituteInPlace app/src/command.c \
      --replace 'const char *const adb_cmd[] = {"shell", "rm", path};' 'const char *const adb_cmd[] = {"shell", "rm", "-f", path};'
  '';

  nativeBuildInputs = [ makeWrapper meson ninja pkgconfig ];

  buildInputs = [ ffmpeg SDL2 ];

  # Manually install the server jar to prevent Meson from "fixing" it
  preConfigure = ''
    echo -n > server/meson.build
  '';

  mesonFlags = ["-Doverride_server_path=${prebuilt_server}"];
  postInstall = ''
    mkdir -p "$out/share/scrcpy"
    ln -s "${prebuilt_server}" "$out/share/scrcpy/scrcpy-server.jar"

    # runtime dep on `adb` to push the server
    wrapProgram "$out/bin/scrcpy" --prefix PATH : "${platform-tools}/bin"
  '';

  meta = with stdenv.lib; {
    description = "Display and control Android devices over USB or TCP/IP";
    homepage = https://github.com/Genymobile/scrcpy;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ deltaevo lukeadams ];
  };
}
