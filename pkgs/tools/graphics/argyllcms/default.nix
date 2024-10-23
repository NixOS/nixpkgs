{ stdenv, fetchzip, jam, pkg-config, unzip
, libX11, libXxf86vm, libXrandr, libXinerama
, libXrender, libXext, libtiff, libjpeg, libpng, libXScrnSaver, writeText
, libXdmcp, libXau, xorgproto, lib, openssl
, buildPackages, substituteAll, writeScript
}:

stdenv.mkDerivation rec {
  pname = "argyllcms";
  version = "3.3.0";

  src = fetchzip {
    # Kind of flacky URL, it was reaturning 406 and inconsistent binaries for a
    # while on me. It might be good to find a mirror
    url = "https://www.argyllcms.com/Argyll_V${version}_src.zip";
    hash = "sha256-xpbj15GzpGS0d1UjzvYiZ1nmmTjNIyv0ST2blmi7ZSk=";
  };

  nativeBuildInputs = [ jam pkg-config unzip ];

  patches = lib.optional (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) (
    # Build process generates files by compiling and then invoking an executable.
    substituteAll {
      src = ./jam-cross.patch;
      emulator = stdenv.hostPlatform.emulator buildPackages;
    }
  );

  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace Jambase \
      --replace "-m64" ""
  '';

  preConfigure = ''
    # Remove tiff, jpg and png to be sure the nixpkgs-provided ones are used
    rm -rf tiff jpg png

    substituteInPlace Jamtop \
      --replace-fail /usr/X11R6/include ${lib.getDev xorgproto}/include \
      --replace-fail /usr/X11R6/lib ${lib.getLib libX11}/lib

    jamFlagsArray=(
      -q -fJambase -j "$NIX_BUILD_CORES"
      -s DESTDIR=/
      -s REFSUBDIR=share/argyllcms
      -s PREFIX="$out"
      -s HAVE_JPEG=true
      -s HAVE_TIFF=true
      -s HAVE_PNG=true
      -s HAVE_Z=true
      -s HAVE_SSL=true
      -s LINKFLAGS="$($PKG_CONFIG --libs libjpeg libtiff-4 libpng zlib libssl)"
      -s GUILINKFLAGS="$($PKG_CONFIG --libs x11 xext xxf86vm xinerama xrandr xau xdmcp xscrnsaver)"
    )

    export AR="$AR rusc"
  '';

  buildInputs = [
    libtiff libjpeg libpng libX11 libXxf86vm libXrandr libXinerama libXext
    libXrender libXScrnSaver libXdmcp libXau openssl
  ];

  buildPhase = ''
    runHook preBuild

    jam "''${jamFlagsArray[@]}"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    jam "''${jamFlagsArray[@]}" install

    # Install udev rules, but remove lines that set up the udev-acl
    # stuff, since that is handled by udev's own rules (70-udev-acl.rules)
    rm -v $out/bin/License.txt
    mkdir -p $out/etc/udev/rules.d
    sed -i '/udev-acl/d' usb/55-Argyll.rules
    cp -v usb/55-Argyll.rules $out/etc/udev/rules.d/

    sed -i -e 's/^CREATED .*/CREATED "'"$(date -d @$SOURCE_DATE_EPOCH)"'"/g' $out/share/argyllcms/RefMediumGamut.gam

    runHook postInstall
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
    platforms = platforms.linux;
  };
}
