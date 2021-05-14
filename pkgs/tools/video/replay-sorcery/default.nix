{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, cmake
, pkg-config
, ffmpeg
, libX11
, drmSupport ? true, libdrm
, notifySupport ? true, libnotify
, pulseaudioSupport ? true, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "replay-sorcery";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "matanui159";
    repo = "ReplaySorcery";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-HPkSOwfwcg4jLUzKfqdXgLu7mgD5H4wb9d2BrqWQeHc=";
  };

  # Patch in libnotify if support is enabled.
  patches = lib.optional notifySupport (substituteAll {
    src = ./hardcode-libnotify.patch;
    inherit libnotify;
  });

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ ffmpeg libX11 ]
  ++ lib.optional drmSupport libdrm
  ++ lib.optional pulseaudioSupport libpulseaudio;

  cmakeFlags = [
    "-DRS_SYSTEMD_DIR=${placeholder "out"}/lib/systemd/user"

    # SETUID & SETGID permissions required for hardware accelerated
    # video capture can't be set during the build.
    "-DRS_SETID=OFF"
  ];

  meta = with lib; {
    description = "An open-source, instant-replay solution for Linux";
    homepage = "https://github.com/matanui159/ReplaySorcery";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
