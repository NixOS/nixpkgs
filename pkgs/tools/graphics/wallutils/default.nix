{ lib
, buildGoModule
, fetchFromGitHub
, libX11
, libXcursor
, libXmu
, libXpm
, libheif
, pkg-config
, wayland
, xbitmaps
}:

buildGoModule rec {
  pname = "wallutils";
<<<<<<< HEAD
  version = "5.12.7";
=======
  version = "5.12.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-7UqZr/DEiHDgg3XwvsKk/gc6FNtLh3aj5NWVz/A3J4o=";
  };

  vendorHash = null;
=======
    hash = "sha256-qC+AF+NFXSrUZAYaiFPwvfZtsAGhKE4XFDOUcfXUAbM=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [
    ./000-add-nixos-dirs-to-default-wallpapers.patch
  ];

  excludedPackages = [
    "./pkg/event/cmd" # Development tools
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libX11
    libXcursor
    libXmu
    libXpm
    libheif
    wayland
    xbitmaps
  ];

  ldflags = [ "-s" "-w" ];

  preCheck =
    let skippedTests = [
      "TestClosest" # Requiring Wayland or X
      "TestEveryMinute" # Blocking
      "TestNewSimpleEvent" # Blocking
    ]; in
    ''
      export XDG_RUNTIME_DIR=`mktemp -d`

      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  meta = {
    description = "Utilities for handling monitors, resolutions, and (timed) wallpapers";
    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.AndersonTorres ];
    inherit (wayland.meta) platforms;
    badPlatforms = lib.platforms.darwin;
  };
}
