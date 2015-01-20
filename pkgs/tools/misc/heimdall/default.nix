{ stdenv, fetchFromGitHub, pkgconfig, libusb1, udev
, enableGUI ? true, qt4 ? null
}:

stdenv.mkDerivation rec {
  version = "1.4.1";
  name = "heimdall-${version}";

  src = fetchFromGitHub {
    owner  = "Benjamin-Dobell";
    repo   = "Heimdall";
    rev    = "v${version}";
    sha256 = "1b7xpamwvw5r2d9yf73f0axv35vg8zaz1345xs3lmsr105phnnp4";
  };

  buildInputs =
    [ pkgconfig libusb1 udev ]
    ++ stdenv.lib.optional enableGUI qt4 ;

  makeFlags = "udevrulesdir=$(out)/lib/udev/rules.d";

  preConfigure =
    ''
      pushd libpit
      ./configure
      make
      popd

      cd heimdall
      substituteInPlace Makefile.in --replace sudo true

      # Give ownership of the Galaxy S USB device to the logged in
      # user.
      substituteInPlace 60-heimdall-galaxy-s.rules --replace 'MODE="0666"' 'TAG+="udev-acl"'
    '';

  postBuild = stdenv.lib.optionalString enableGUI
    ''
      pushd ../heimdall-frontend
      substituteInPlace Source/mainwindow.cpp --replace /usr/bin $out/bin
      qmake heimdall-frontend.pro OUTPUTDIR=$out/bin
      make
      popd
    '';

  postInstall =
    ''
      mkdir -p $out/share/doc/heimdall
      cp ../Linux/README $out/share/doc/heimdall/
    '' + stdenv.lib.optionalString enableGUI ''
      make -C ../heimdall-frontend install
    '';

  meta = {
    homepage = http://www.glassechidna.com.au/products/heimdall/;
    description = "A cross-platform open-source tool suite used to flash firmware onto Samsung Galaxy S devices";
    license = stdenv.lib.licenses.mit;
  };
}
