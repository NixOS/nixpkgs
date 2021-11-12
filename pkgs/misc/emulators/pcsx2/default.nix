{ alsa-lib
, cmake
, fetchFromGitHub
, fmt
, gettext
, glib
, gtk3
, harfbuzz
, libaio
, libpcap
, libpng
, libpulseaudio
, libsamplerate
, libxml2
, perl
, pkg-config
, portaudio
, SDL2
, soundtouch
, lib, stdenv
, udev
, wrapGAppsHook
, wxGTK
, zlib
}:

stdenv.mkDerivation {
  pname = "pcsx2";
  version = "unstable-2021-10-28";

  src = fetchFromGitHub {
    owner = "PCSX2";
    repo = "pcsx2";
    fetchSubmodules = true;
    rev = "52eab493591137d830b45337e04c75ff525a31f9";
    sha256 = "RhAo5Fob8G16jzb9MOAS43vwTkFzf5XupymN0dzeGJU=";
  };

  cmakeFlags = [
    "-DDISABLE_ADVANCE_SIMD=TRUE"
    "-DDISABLE_PCSX2_WRAPPER=TRUE"
    "-DPACKAGE_MODE=TRUE"
    "-DXDG_STD=TRUE"
  ];

  nativeBuildInputs = [ cmake perl pkg-config wrapGAppsHook ];

  buildInputs = [
    alsa-lib
    fmt
    gettext
    glib
    gtk3
    harfbuzz
    libaio
    libpcap
    libpng
    libpulseaudio
    libsamplerate
    libxml2
    portaudio
    SDL2
    soundtouch
    udev
    wxGTK
    zlib
  ];

  meta = with lib; {
    description = "Playstation 2 emulator";
    longDescription= ''
      PCSX2 is an open-source PlayStation 2 (AKA PS2) emulator. Its purpose
      is to emulate the PS2 hardware, using a combination of MIPS CPU
      Interpreters, Recompilers and a Virtual Machine which manages hardware
      states and PS2 system memory. This allows you to play PS2 games on your
      PC, with many additional features and benefits.
    '';
    homepage = "https://pcsx2.net";
    maintainers = with maintainers; [ hrdinka govanify ];
    mainProgram = "PCSX2";

    # PCSX2's source code is released under LGPLv3+. It However ships
    # additional data files and code that are licensed differently.
    # This might be solved in future, for now we should stick with
    # license.free
    license = licenses.free;
    platforms = platforms.x86;
  };
}
