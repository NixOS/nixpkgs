<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, gcc-arm-embedded
, readline
, bzip2
, openssl
, jansson
, whereami
, lua
, Foundation
, AppKit
, withGui ? true, wrapQtAppsHook, qtbase
, withPython ? true, python3
, withBlueshark ? false, bluez5
, withGeneric ? false
, withSmall ? false
, withoutFunctions ? []
, hardwarePlatform ? if withGeneric then "PM3GENERIC" else "PM3RDV4"
, hardwarePlatformExtras ? lib.optionalString withBlueshark "BTADDON"
, standalone ? "LF_SAMYRUN"
}:
assert withBlueshark -> stdenv.hostPlatform.isLinux;
stdenv.mkDerivation rec {
  pname = "proxmark3";
  version = "4.16717";

  src = fetchFromGitHub {
    owner = "RfidResearchGroup";
    repo = "proxmark3";
    rev = "v${version}";
    sha256 = "sha256-rkfVgT+9fqlWvUXzLH28Nzd8HldJnU+IZz8conY8Mis=";
  };

  patches = [
    # Don't check for DISPLAY env variable on Darwin. pm3 uses this to test if
    # XQuartz is installed, however it is not actually required for GUI features
    ./darwin-always-gui.patch
  ];

  postPatch = ''
    # Remove hardcoded paths on Darwin
    substituteInPlace Makefile.defs \
      --replace "/usr/bin/ar" "ar" \
      --replace "/usr/bin/ranlib" "ranlib"
    # Replace hardcoded path to libwhereami
    substituteInPlace client/Makefile \
      --replace "/usr/include/whereami.h" "${whereami}/include/whereami.h"
  '';

  nativeBuildInputs = [
    pkg-config
    gcc-arm-embedded
  ] ++ lib.optional withGui wrapQtAppsHook;
  buildInputs = [
    readline
    bzip2
    openssl
    jansson
    whereami
    lua
  ] ++ lib.optional withGui qtbase
    ++ lib.optional withPython python3
    ++ lib.optional withBlueshark bluez5
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation AppKit ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "UDEV_PREFIX=${placeholder "out"}/etc/udev/rules.d"
    "PLATFORM=${hardwarePlatform}"
    "PLATFORM_EXTRAS=${hardwarePlatformExtras}"
    "STANDALONE=${standalone}"
    "USE_BREW=0"
  ] ++ lib.optional withSmall "PLATFORM_SIZE=256"
    ++ map (x: "SKIP_${x}=1") withoutFunctions;
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Client for proxmark3, powerful general purpose RFID tool";
    homepage = "https://github.com/RfidResearchGroup/proxmark3";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nyanotech emilytrau ];
    platforms = platforms.unix;
=======
{ lib, stdenv, fetchFromGitHub, pkg-config, ncurses, readline, pcsclite, qt5
, gcc-arm-embedded }:

let
  generic = { pname, version, rev, sha256 }:
    stdenv.mkDerivation rec {
      inherit pname version;

      src = fetchFromGitHub {
        owner = "Proxmark";
        repo = "proxmark3";
        inherit rev sha256;
      };

      nativeBuildInputs = [ pkg-config gcc-arm-embedded ];
      buildInputs = [ ncurses readline pcsclite qt5.qtbase ];

      dontWrapQtApps = true;

      postPatch = ''
        substituteInPlace client/Makefile --replace '-ltermcap' ' '
        substituteInPlace liblua/Makefile --replace '-ltermcap' ' '
        substituteInPlace client/flasher.c \
          --replace 'armsrc/obj/fullimage.elf' \
                    '${placeholder "out"}/firmware/fullimage.elf'
      '';

      buildPhase = ''
        make bootrom/obj/bootrom.elf armsrc/obj/fullimage.elf client
      '';

      installPhase = ''
        install -Dt $out/bin client/proxmark3
        install -T client/flasher $out/bin/proxmark3-flasher
        install -Dt $out/firmware bootrom/obj/bootrom.elf armsrc/obj/fullimage.elf
      '';

      meta = with lib; {
        description = "Client for proxmark3, powerful general purpose RFID tool";
        homepage = "http://www.proxmark.org";
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [ fpletz ];
      };
    };
in

{
  proxmark3 = generic rec {
    pname = "proxmark3";
    version = "3.1.0";
    rev = "v${version}";
    sha256 = "1qw28n1bhhl91ix77lv50qcr919fq3hjc8zhhqphwxal2svgx2jf";
  };

  proxmark3-unstable = generic {
    pname = "proxmark3-unstable";
    version = "2019-12-28";
    rev = "a4ff62be63ca2a81071e9aa2b882bd3ff57f13ad";
    sha256 = "067lp28xqx61n3i2a2fy489r5frwxqrcfj8cpv3xdzi3gb3vk5c3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
