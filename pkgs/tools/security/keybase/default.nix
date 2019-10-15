{ stdenv, lib, buildGoPackage, fetchFromGitHub
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox
}:

buildGoPackage rec {
  pname = "keybase";
  version = "4.3.1";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    sha256 = "1743d7a7ix882yxz9pk230vdvdj46sbscqv4wqyhb0la2pl9jqdp";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox ];
  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
  };
}
