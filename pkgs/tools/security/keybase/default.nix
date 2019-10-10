{ stdenv, lib, buildGoPackage, fetchFromGitHub
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox
}:

buildGoPackage rec {
  pname = "keybase";
  version = "4.6.0";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    sha256 = "a25f0c676c00d306859d32e4dad7a23dd4955fa0b352be50c281081f2cf000ae";
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
