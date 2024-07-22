{
  lib,
  stdenv,
  fetchzip,
  jam,
  unzip,
  # writeText,
  buildPackages,
  substituteAll,
  writeScript,

  # Common deps
  openssl,
  libtiff,
  libjpeg,
  libpng,
  libusb1,

  # Linux specific
  libX11,
  libXxf86vm,
  libXrandr,
  libXinerama,
  libXrender,
  libXext,
  libXScrnSaver,
  libXdmcp,
  libXau,

  # MacOS specific
  darwin,
}:

let
  inherit (darwin.apple_sdk.frameworks)
    AppKit
    AudioToolbox
    Carbon
    Cocoa
    CoreFoundation
    IOKit
    ;
in

stdenv.mkDerivation rec {
  pname = "argyllcms";
  version = "3.2.0";

  src = fetchzip {
    # Kind of flacky URL, it was reaturning 406 and inconsistent binaries for a
    # while on me. It might be good to find a mirror
    url = "https://www.argyllcms.com/Argyll_V${version}_src.zip";
    hash = "sha256-t2dvbYFHEz9IUYpcM5HqDju4ugHrD7seG3QxumspxDg=";
  };

  nativeBuildInputs = [
    jam
    unzip
  ];

  buildInputs =
    [
      libtiff
      libjpeg
      libpng
      openssl
      libusb1
    ]
    ++ lib.optionals stdenv.isLinux [
      libX11
      libXxf86vm
      libXrandr
      libXinerama
      libXext
      libXrender
      libXScrnSaver
      libXdmcp
      libXau
    ]
    ++ lib.optionals stdenv.isDarwin [
      AppKit
      AudioToolbox
      Carbon
      Cocoa
      CoreFoundation
      IOKit
    ];

  buildFlags = [ "all" ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "REFSUBDIR=share/argyllcms"
  ];

  patches = lib.optional (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) (
    # Build process generates files by compiling and then invoking an executable.
    substituteAll {
      src = ./jam-cross.patch;
      emulator = stdenv.hostPlatform.emulator buildPackages;
    }
  );

  postPatch = ''
      substituteInPlace Makefile --replace-fail "-j 3" "-j $NIX_BUILD_CORES"
      substituteInPlace Jamtop --replace-fail "EXIT Unable" "ECHO Unable"

      # Keep udev rules
      mkdir udev-rules
      mv usb/*.rules udev-rules

      # Remove bundled libraries, making the build fail if not provided externally
      rm -rf tiff jpeg png usb zlib

      export AR="$AR rusc"

      cat "$extraJamtopPath" >> Jamtop
  '' + lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace Jambase --replace-fail "-m64" ""
  '';

  extraJamtop =
    let
      commonLinkFlags = "-ljpeg -lpng -ltiff -lusb-1.0 -lz -lssl";
      markPresent = name: ''
        HAVE_${name} = true ;
        ${name}INC = ;
        ${name}LIB = ;
      '';
    in
    ''
      ${markPresent "JPEG"}
      ${markPresent "PNG"}
      ${markPresent "SSL"}
      ${markPresent "TIFF"}
      ${markPresent "Z"}
      ${markPresent "ZLIB"}

      ${lib.optionalString stdenv.isLinux ''
        LINKFLAGS = ${lib.concatMapStringsSep " " (dep: "-L${lib.getOutput "lib" dep}/lib") buildInputs} ;
        LINKFLAGS += -ldl -lrt ${commonLinkFlags} ;
        GUILINKFLAGS = -lX11 -lXext -lXxf86vm -lXinerama -lXrandr -lXau -lXdmcp -lXss ;
      ''}

      ${lib.optionalString stdenv.isDarwin ''
        LINKFLAGS += ${commonLinkFlags} ;
      ''}
    '';

  passAsFile = [ "extraJamtop" ];

  postInstall = ''
    sed -i -e 's/^CREATED .*/CREATED "'"$(date -d @$SOURCE_DATE_EPOCH)"'"/g' $out/share/argyllcms/RefMediumGamut.gam

    ${lib.optionalString stdenv.isLinux ''
      install -Dm444 udev-rules/55-Argyll.rules $out/etc/udev/rules.d/55-Argyll.rules
    ''}
  '';

  passthru = {
    updateScript = writeScript "update-argyllcms" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of 'Current Version 3.0.1 (19th October 2023)'
      new_version="$(curl -s https://www.argyllcms.com/ |
          pcregrep -o1 '>Current Version ([0-9.]+) ')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = with lib; {
    homepage = "https://www.argyllcms.com/";
    description = "Color management system (compatible with ICC)";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
