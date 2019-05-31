{ stdenv, fetchurl, fetchFromGitHub, makeWrapper
, meson
, ninja
, pkgconfig

, platform-tools
, ffmpeg
, SDL2
}:

let
  version = "1.8";
  prebuilt_server = fetchurl {
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}.jar";
    sha256 = "1h755k5xpchlm7wq2yk5mlwjnh7y4yhviffixacby0srj3pmb443";
  };
in
stdenv.mkDerivation rec {
  pname = "scrcpy";
  inherit version;

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cx7y3w699s3i8s53l1mb7lkrnbix457hf17liwh00jzb0i7aga7";
  };

  # postPatch:
  #   screen.c: When run without a hardware accelerator, this allows the command to continue working rather than failing unexpectedly.
  #   This can happen when running on non-NixOS because then scrcpy seems to have a hard time using the host OpenGL-supporting hardware.
  #   It would be better to fix the OpenGL problem, but that seems much more intrusive.
  postPatch = ''
    substituteInPlace app/src/screen.c \
      --replace "SDL_RENDERER_ACCELERATED" "SDL_RENDERER_ACCELERATED || SDL_RENDERER_SOFTWARE"
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
