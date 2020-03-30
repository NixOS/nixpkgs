{ stdenv, substituteAll, lib, buildGoPackage, fetchFromGitHub
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox
, gnupg
}:

buildGoPackage rec {
  pname = "keybase";
  version = "5.3.1";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/kbnm" "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    sha256 = "1a1h2c8jr4r20w4gyvyrpsslmh69bl8syl3jbr0fcr2kka7vqnzg";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths-keybase.patch;
      gpg = "${gnupg}/bin/gpg";
      gpg2 = "${gnupg}/bin/gpg2";
    })
  ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox ];
  buildFlags = [ "-tags production" ];

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs filalex77 ];
    license = licenses.bsd3;
  };
}
