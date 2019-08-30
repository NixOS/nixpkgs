{ stdenv, fetchurl, autoreconfHook, boost, gtkmm2
, pkg-config, libtool, udev, libjpeg, file, texlive
, libusb, libtiff, imagemagick, sane-backends, tesseract }:

/*
Alternatively, this package could use the "community source" at 
https://gitlab.com/utsushi/utsushi/
Epson provides proprietary plugins for networking, ocr and some more
scanner models. Those are not (yet ?) packaged here.
*/

stdenv.mkDerivation rec {
  pname = "utsushi";
  version = "3.57.0";

  src = fetchurl {
    url = "http://support.epson.net/linux/src/scanner/imagescanv3/common/imagescan_${version}.orig.tar.gz";
    sha256 = "0qy6n6nbisbvy0q3idj7hpmj9i85cd0a18klfd8nsqsa2nkg57ny";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libtool
  ];

  buildInputs = [
    boost
    libusb
    libtiff
    libjpeg
    udev
    imagemagick
    sane-backends
    gtkmm2
    file
    tesseract
  ];

  patches = [
    ./patches/absolute-path-to-convert.patch
    ./patches/print-errors.patch
    ./patches/absolute_path_for_tesseract.patch
  ];

  postPatch = ''
    # remove vendored dependencies
    rm -r upstream/boost
    # create fake udev and sane config
    mkdir -p $out/etc/{sane.d,udev/rules.d}
    touch $out/etc/sane.d/dll.conf
  '';

  configureFlags = [
    "--with-boost-libdir=${boost}/lib"
    "--with-sane-confdir=${placeholder "out"}/etc/sane.d"
    "--with-udev-confdir=${placeholder "out"}/etc/udev"
    "--with-sane"
    "--with-gtkmm"
    "--with-jpeg"
    "--with-magick"
    "--with-sane"
    "--with-tiff"
  ];

  installFlags = [ "SANE_BACKENDDIR=${placeholder "out"}/lib/sane" ];

  enableParallelBuilding = true;

  meta = {
    description = "SANE utsushi backend for some Epson scanners";
    longDescription = ''
        ImageScanV3 (aka utsushi) scanner driver.
        Non-free plugins are not included so no network support.
        To use the SANE backend, in /etc/nixos/configuration.nix:

        hardware.sane = {
          enable = true;
          extraBackends = [ pkgs.utsushi ];
        };
        services.udev.packages = [ pkgs.utsushi ];

        Supported hardware: 
        - DS-40
        - DS-70
        - DS-80W
        - DS-410
        - DS-510
        - DS-520
        - DS-530
        - DS-535
        - DS-535H
        - DS-560
        - DS-575W
        - DS-760
        - DS-775
        - DS-780N
        - DS-860
        - DS-1630
        - DS-5500
        - DS-6500
        - DS-7500
        - DS-50000
        - DS-60000
        - DS-70000
        - EP-10VA Series
        - EP-808A Series
        - EP-978A3 Series
        - ES-50
        - ES-55R
        - ES-60W
        - ES-65WR
        - ES-300WR
        - ES-400
        - ES-500WR
        - ES-8500
        - ET-2500 Series
        - ET-2550 Series
        - ET-4500 Series
        - ET-4550 Series
        - Expression 1640XL
        - FF-680W
        - L220/L360 Series
        - L365/L366 Series
        - L380 Series
        - L455 Series
        - L565/L566 Series
        - L655 Series
        - PX-M840FX
        - PX-M860F
        - PX-M884F
        - PX-M7050 Series
        - PX-M7050FX Series
        - WF-4720
        - WF-6530 Series
        - WF-6590 Series
        - WF-8510/8590 Series
        - WF-R8590 Series
        - XP-220 Series
        - XP-230 Series
        - XP-235 Series
        - XP-332 335 Series
        - XP-430 Series
        - XP-432 435 Series
        - XP-530 Series
        - XP-540
        - XP-630 Series
        - XP-640
        - XP-830 Series
        - XP-960 Series
      '';
      license = stdenv.lib.licenses.gpl3Plus;
  };
}
