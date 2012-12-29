{ stdenv, fetchurl, jam, unzip, libX11, libXxf86vm, libXrandr, libXinerama
, libXrender, libXext, libtiff, libjpeg, libXScrnSaver, writeText
, libXdmcp, libXau, lib }:

stdenv.mkDerivation rec {
  name = "argyllcms-1.4.0";

  src = fetchurl {
    url = "http://www.argyllcms.com/Argyll_V1.4.0_src.zip";
    sha256 = "1a5i0972cjp6asmawmyzih2y4bv3i0qvf7p6z5lxnr199mq38cfk";
  };

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
    
    # Use libusb1 rather than libusb0 & libusb0-win32
    USE_LIBUSB1 = true ;
    
    # Make the USB V1 library static
    LIBUSB_IS_DLL = false ;
    
    # Set the libubs1 library name.
    LIBUSB1NAME = libusb-1A ;

    JPEGLIB = ;
    JPEGINC = ;
    HAVE_JPEG = true ;

    TIFFLIB = ;
    TIFFINC = ;
    HAVE_TIFF = true ;

    LINKFLAGS +=
      ${lib.concatStringsSep " " (map (x: "-L${x}/lib") buildInputs)}
      -ldl -lrt -lX11 -lXext -lXxf86vm -lXinerama -lXrandr -lXau -lXdmcp -lXss
      -ljpeg -ltiff ;
  '';

  buildNativeInputs = [ jam unzip ];

  preConfigure = ''
    cp ${jamTop} Jamtop
    substituteInPlace Makefile --replace "-j 3" "-j $NIX_BUILD_CORES"
    # Remove tiff and jpg to be sure the nixpkgs-provided ones are used
    rm -rf tiff jpg
  '';

  buildInputs = [ 
    libtiff libjpeg libX11 libXxf86vm libXrandr libXinerama libXext
    libXrender libXScrnSaver libXdmcp libXau
  ];

  buildFlags = "PREFIX=$(out) all";

  installFlags = "PREFIX=$(out)";

  # Install udev rules, but remove lines that set up the udev-acl and plugdev
  # stuff, since that is handled by udev's own rules (70-udev-acl.rules)
  postInstall = ''
    rm -v $out/bin/License.txt
    mkdir -p $out/etc/udev/rules.d
    sed -i '/udev-acl/d' libusb1/55-Argyll.rules
    sed -i '/plugdev/d' libusb1/55-Argyll.rules
    cp -v libusb1/55-Argyll.rules $out/etc/udev/rules.d/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.argyllcms.com;
    description = "An ICC compatible color management system";
    license = licenses.gpl3;
    maintainers = [ maintainers.rickynils ];
    platforms = platforms.linux;
  };
}
