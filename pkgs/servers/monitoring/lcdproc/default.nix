{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

    # Pull upstream fix for -fno-common toolchains:
    #   https://github.com/lcdproc/lcdproc/pull/148
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/lcdproc/lcdproc/commit/fda5302878692da933dc03cd011f8ddffefa07a4.patch";
      sha256 = "0ld6p1r4rjsnjr63afw3lp5lx25jxjs07lsp9yc3q96r91r835cy";
    })
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
    homepage = "https://lcdproc.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
