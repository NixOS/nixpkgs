{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, makeWrapper
, pkg-config
, doxygen
, freetype
, libX11
, libftdi
, libusb-compat-0_1
, libusb1
, ncurses
, perl
}:

stdenv.mkDerivation rec {
  pname = "lcdproc";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "lcdproc";
    repo = "lcdproc";
    rev = "v${version}";
    sha256 = "1r885zv1gsh88j43x6fvzbdgfkh712a227d369h4fdcbnnfd0kpm";
  };

  patches = [
    ./hardcode_mtab.patch
  ];

  # we don't need to see the GPL every time we launch lcdd in the foreground
  postPatch = ''
    substituteInPlace server/main.c \
      --replace 'output_GPL_notice();' '// output_GPL_notice();'
  '';

  configureFlags = [
    "--enable-lcdproc-menus"
    "--enable-drivers=all"
    "--with-pidfile-dir=/run"
  ];

  buildInputs = [ freetype libX11 libftdi libusb-compat-0_1 libusb1 ncurses ];

  nativeBuildInputs = [ autoreconfHook doxygen makeWrapper pkg-config ];

  # In 0.5.9: gcc: error: libbignum.a: No such file or directory
  enableParallelBuilding = false;

  postFixup = ''
    for f in $out/bin/*.pl ; do
      substituteInPlace $f \
        --replace /usr/bin/perl ${lib.getBin perl}/bin/perl
    done

    # NixOS will not use this file anyway but at least we can now execute LCDd
    substituteInPlace $out/etc/LCDd.conf \
      --replace server/drivers/ $out/lib/lcdproc/
  '';

  meta = with lib; {
    description = "Client/server suite for controlling a wide variety of LCD devices";
    homepage = "http://lcdproc.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
