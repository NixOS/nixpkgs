{ stdenv, fetchzip, jam, unzip, libX11, libXxf86vm, libXrandr, libXinerama
, libXrender, libXext, libtiff, libjpeg, libpng, libXScrnSaver, writeText
, libXdmcp, libXau, lib, openssl }:

stdenv.mkDerivation rec {
  pname = "argyllcms";
  version = "2.3.0";

  src = fetchzip {
    # Kind of flacky URL, it was reaturning 406 and inconsistent binaries for a
    # while on me. It might be good to find a mirror
    url = "https://www.argyllcms.com/Argyll_V${version}_src.zip";
    sha256 = "sha256-UNjCcqJgbRSox55OP3pLdKFHY0NPLHEq3nwqvxWre7U=";
  };

  nativeBuildInputs = [ jam unzip ];

  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    substituteInPlace Jambase \
      --replace "-m64" ""
  '';

  preConfigure = let
    # The contents of this file comes from the Jamtop file from the
    # root of the ArgyllCMS distribution, rewritten to pick up Nixpkgs
    # library paths. When ArgyllCMS is updated, make sure that changes
    # in that file is reflected here.
    jamTop = writeText "argyllcms_jamtop" ''
      DESTDIR = "/" ;
      REFSUBDIR = "share/argyllcms" ;

      # Keep this DESTDIR anchored to Jamtop. PREFIX is used literally
      ANCHORED_PATH_VARS = DESTDIR ;

      # Tell standalone libraries that they are part of Argyll:
      DEFINES += ARGYLLCMS ;

      # enable serial instruments & support
      USE_SERIAL = true ;

      # enable fast serial instruments & support
      USE_FAST_SERIAL = true ;                # (Implicit in USE_SERIAL too)

      # enable USB instruments & support
      USE_USB = true ;

      # enable dummy Demo Instrument (only if code is available)
      USE_DEMOINST = true ;

      # enable Video Test Patch Generator and 3DLUT device support
      # (V2.0.0 and above)
      USE_VTPGLUT = false ;

      # enable Printer device support
      USE_PRINTER = false ;

      # enable CMF Measurement device and accessory support (if present)
      USE_CMFM = false ;

      # Use ArgyllCMS version of libusb (deprecated - don't use)
      USE_LIBUSB = false ;

      # Compile in graph plotting code (Not fully implemented)
      USE_PLOT = true ;		# [true]

      JPEGLIB = ;
      JPEGINC = ;
      HAVE_JPEG = true ;

      TIFFLIB = ;
      TIFFINC = ;
      HAVE_TIFF = true ;

      PNGLIB = ;
      PNGINC = ;
      HAVE_PNG = true ;

      ZLIB = ;
      ZINC = ;
      HAVE_Z = true ;

      SSLLIB = ;
      SSLINC = ;
      HAVE_SSL = true ;

      LINKFLAGS +=
        ${lib.concatStringsSep " " (map (x: "-L${x}/lib") buildInputs)}
        -ldl -lrt -lX11 -lXext -lXxf86vm -lXinerama -lXrandr -lXau -lXdmcp -lXss
        -ljpeg -ltiff -lpng -lssl ;
    '';
  in ''
    cp ${jamTop} Jamtop
    substituteInPlace Makefile --replace "-j 3" "-j $NIX_BUILD_CORES"
    # Remove tiff, jpg and png to be sure the nixpkgs-provided ones are used
    rm -rf tiff jpg png

    export AR="$AR rusc"
  '';

  buildInputs = [
    libtiff libjpeg libpng libX11 libXxf86vm libXrandr libXinerama libXext
    libXrender libXScrnSaver libXdmcp libXau openssl
  ];

  buildFlags = [ "all" ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  # Install udev rules, but remove lines that set up the udev-acl
  # stuff, since that is handled by udev's own rules (70-udev-acl.rules)
  postInstall = ''
    rm -v $out/bin/License.txt
    mkdir -p $out/etc/udev/rules.d
    sed -i '/udev-acl/d' usb/55-Argyll.rules
    cp -v usb/55-Argyll.rules $out/etc/udev/rules.d/

    sed -i -e 's/^CREATED .*/CREATED "'"$(date -d @$SOURCE_DATE_EPOCH)"'"/g' $out/share/argyllcms/RefMediumGamut.gam

  '';

  meta = with lib; {
    homepage = "http://www.argyllcms.com";
    description = "Color management system (compatible with ICC)";
    license = licenses.gpl3;
    maintainers = [];
    platforms = platforms.linux;
  };
}
