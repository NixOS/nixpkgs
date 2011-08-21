{ stdenv, fetchgit, pkgconfig, libusb1, udev
, enableGUI ? true, qt4 ? null
}:

stdenv.mkDerivation {
  name = "heimdall-1.3.0";

  src = fetchgit {
    url = git://github.com/Benjamin-Dobell/Heimdall.git;
    rev = "ed9b08e5d9e3db60d52bccf6cb6919fb4bd47602";
    sha256 = "e65f18299a05699595548cb27393a01b4e1dbbced82d4add8d0d55ef6514a691";
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
    license = "bsd";
  };
}
