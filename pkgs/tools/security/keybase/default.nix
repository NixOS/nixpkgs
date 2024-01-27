{ stdenv, substituteAll, lib, buildGoModule, fetchFromGitHub
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox, gnupg
}:

buildGoModule rec {
  pname = "keybase";
  version = "6.2.4";

  modRoot = "go";
  subPackages = [ "kbnm" "keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    hash = "sha256-z7vpCUK+NU7xU9sNBlQnSy9sjXD7/m8jSRKfJAgyyN8=";
  };
  vendorHash = "sha256-tXEEVEfjoKub2A4m7F3hDc5ABJ+R+axwX1+1j7e3BAM=";

  patches = [
    (substituteAll {
      src = ./fix-paths-keybase.patch;
      gpg = "${gnupg}/bin/gpg";
      gpg2 = "${gnupg}/bin/gpg2";
    })
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox ];
  tags = [ "production" ];
  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://www.keybase.io/";
    description = "The Keybase official command-line utility and service";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ avaq np rvolosatovs Br1ght0ne shofius ];
    license = licenses.bsd3;
  };
}
