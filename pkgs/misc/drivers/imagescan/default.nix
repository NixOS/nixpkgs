{ stdenv, fetchFromGitLab, pkgconfig, patchelf, boost, udev, libusb, imagemagick
, sane-backends, gtkmm2 }:

stdenv.mkDerivation rec {
  pname = "imagescan";
  version = "3.59.2";

  src = fetchFromGitLab{
    owner = "utsushi";
    repo = pname;
    rev = version;
    sha256 = "06gp97dfnf43l6kb988scmm66q9n5rc7ndwv3rykrdpyhy8rbi05";
  };

  configureFlags = [ 
    "--with-boost-libdir=${boost}/lib"
    "--with-sane-confdir=${placeholder "out"}/etc/sane.d"
    "--with-udev-confdir=${placeholder "out"}/etc/udev"
    "--with-gtkmm"
    "--with-jpeg"
    "--with-magick"
    "--with-sane"
    "--with-tiff"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=unused-variable" "-Wno-error=parentheses" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev libusb.dev boost imagemagick sane-backends gtkmm2 ];
  enableParallelBuilding = true;

  installFlags = [ "SANE_BACKENDDIR=${placeholder "out"}/lib/sane" ];
  doInstallCheck = true;

  meta = with stdenv.lib; {
    description = "A Next Generation Image Acquisition & Epson scanner driver";
    longDescription = ''
      This software provides applications to easily turn hard-copy
      documents and imagery into formats that are more amenable to
      computer processing.

      Included are a native driver for a number of EPSON scanners
      and a compatibility driver to interface with software built
      around the SANE standard.
    '';
    homepage = "https://gitlab.com/utsushi/imagescan";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux;
  };
}
