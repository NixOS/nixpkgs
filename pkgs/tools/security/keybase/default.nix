{ stdenv, lib, buildGoPackage, fetchurl, cf-private
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox
}:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "4.0.0";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchurl {
    url = "https://github.com/keybase/client/archive/v${version}.tar.gz";
    sha256 = "14c0876mxz3xa2k4d665kf8j6k3hc6qybkj0gr4pr9c9gs70cgjh";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox
    # Needed for OBJC_CLASS_$_NSData symbols.
    cf-private
  ];
  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
  };
}
