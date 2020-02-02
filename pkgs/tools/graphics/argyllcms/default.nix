{ stdenv, fetchzip, jam, unzip, libX11, libXxf86vm, libXrandr, libXinerama
, libXrender, libXext, libtiff, libjpeg, libpng, libXScrnSaver, writeText
, libXdmcp, libXau, lib, openssl }:
let
  version = "2.1.2";
 in
stdenv.mkDerivation rec {
  pname = "argyllcms";
  inherit version;

  src = fetchzip {
    # Kind of flacky URL, it was reaturning 406 and inconsistent binaries for a
    # while on me. It might be good to find a mirror
    url = "https://www.argyllcms.com/Argyll_V${version}_src.zip";
    sha256 = "1bsi795kphr1a8l2kvvm9qfkvgfpimds4ijalnmg23wnr8691md1";

    # The argyllcms web server doesn't like curl ...
    curlOpts = "--user-agent 'Mozilla/5.0'";
  };

  patches = [ ./gcc5.patch ];

  # The contents of this file comes from the Jamtop file from the
  # root of the ArgyllCMS distribution, rewritten to pick up Nixpkgs
  # library paths. When ArgyllCMS is updated, make sure that changes
  # in that file is reflected here.
  jamTop = writeText "argyllcms_jamtop" ''
    DESTDIR = "/" ;
    REFSUBDIR = "ref" ;

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

    # Use ArgyllCMS version of libusb (deprecated - don't use)
    USE_LIBUSB = false ;

    # For testing CCast
    DEFINES += CCTEST_PATTERN ;

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

  nativeBuildInputs = [ jam unzip ];

  preConfigure = ''
    cp ${jamTop} Jamtop
    substituteInPlace Makefile --replace "-j 3" "-j $NIX_BUILD_CORES"
    # Remove tiff, jpg and png to be sure the nixpkgs-provided ones are used
    rm -rf tiff jpg png

    unset AR
  '';

  buildInputs = [
    libtiff libjpeg libpng libX11 libXxf86vm libXrandr libXinerama libXext
    libXrender libXScrnSaver libXdmcp libXau openssl
  ];

  buildFlags = [ "all" ];

  makeFlags = [
    "PREFIX=${placeholder ''out''}"
  ];

  # Install udev rules, but remove lines that set up the udev-acl
  # stuff, since that is handled by udev's own rules (70-udev-acl.rules)
  #
  # Move ref to a better place (there must be a way to make the install target
  # do that for us)
  postInstall = ''
    rm -v $out/bin/License.txt
    mkdir -p $out/etc/udev/rules.d
    sed -i '/udev-acl/d' usb/55-Argyll.rules
    cp -v usb/55-Argyll.rules $out/etc/udev/rules.d/
    mkdir -p $out/share/
    mv $out/ref $out/share/argyllcms
  '';

  meta = with stdenv.lib; {
    homepage = http://www.argyllcms.com;
    description = "Color management system (compatible with ICC)";
    license = licenses.gpl3;
    maintainers = [];
    platforms = platforms.linux;
  };
}
