{ stdenv, fetchurl, fetchFromGitHub, makeWrapper
, meson
, ninja
, pkgconfig
, fetchpatch

, platform-tools
, ffmpeg
, SDL2
}:

let
  version = "1.12.1";
  prebuilt_server = fetchurl {
    url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}";
    sha256 = "1sk6hbbnf4g6q58fspwlh8bn16j73j3i8hlcshqxzhfhl746krb3";
  };
in
stdenv.mkDerivation rec {
  pname = "scrcpy";
  inherit version;

  src = fetchFromGitHub {
    owner = "Genymobile";
    repo = pname;
    rev = "v${version}";
    sha256 = "16zi0d2jjm2nlrwkwvsxzfpgy45ami45wfh67wq7na2h2ywfmgcp";
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

  mesonFlags = [ "-Doverride_server_path=${prebuilt_server}" ];
  postInstall = ''
    mkdir -p "$out/share/scrcpy"
    ln -s "${prebuilt_server}" "$out/share/scrcpy/scrcpy-server"

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
