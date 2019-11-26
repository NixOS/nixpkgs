{ stdenv, substituteAll, lib, buildGoPackage, fetchFromGitHub
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox
, gnupg
}:

buildGoPackage rec {
  pname = "keybase";
  version = "5.0.0";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/kbnm" "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    sha256 = "0cxxqmgp82qi2b1fljyfa38is94y8ghb2pd31nbyh8y4wnmi0x1s";
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
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
    license = licenses.bsd3;
  };
}
