{ stdenv, fetchFromGitHub, autoreconfHook, makeWrapper, pkgconfig
, doxygen, freetype, libX11, libftdi, libftdi1, libusb, libusb1, ncurses, perl }:

stdenv.mkDerivation rec {
  name = "lcdproc-${version}";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner  = "lcdproc";
    repo   = "lcdproc";
    rev    = "v${version}";
    sha256 = "1r885zv1gsh88j43x6fvzbdgfkh712a227d369h4fdcbnnfd0kpm";
  };

  patches = [
    ./hardcode_mtab.patch
  ];

  configureFlags = [
    "--enable-lcdproc-menus"
    "--enable-drivers=all"
    "--with-pidfile-dir=/run"
  ];

  buildInputs = [ freetype libX11 libftdi libusb libusb1 ncurses ];
  nativeBuildInputs = [ autoreconfHook doxygen makeWrapper pkgconfig ];

  # In 0.5.9: gcc: error: libbignum.a: No such file or directory
  enableParallelBuilding = false;

  postFixup = ''
    for f in $out/bin/*.pl ; do
      substituteInPlace $f \
        --replace /usr/bin/perl ${stdenv.lib.getBin perl}/bin/perl
    done

    # NixOS will not use this file anyway but at least we can now execute LCDd
    substituteInPlace $out/etc/LCDd.conf \
      --replace server/drivers/ $out/lib/lcdproc/
  '';

  meta = with stdenv.lib; {
    description = "Client/server suite for controlling a wide variety of LCD devices";
    homepage    = http://lcdproc.org/;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
