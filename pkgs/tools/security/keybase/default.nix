{ stdenv, substituteAll, lib, buildGoModule, fetchFromGitHub
, AppKit, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox, gnupg
}:

buildGoModule rec {
  pname = "keybase";
  version = "6.4.0";

  modRoot = "go";
  subPackages = [ "kbnm" "keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    hash = "sha256-hRqxA2gPL1UKbz9DwgfZfjE6e5pB7zenZqK+k1i8F2g=";
  };
  vendorHash = "sha256-KHahkGzkXr6xp0XY9MyEeeiHnmphaNYi9dPBQ476+us=";

  patches = [
    (substituteAll {
      src = ./fix-paths-keybase.patch;
      gpg = "${gnupg}/bin/gpg";
      gpg2 = "${gnupg}/bin/gpg2";
    })
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ AppKit AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox ];
  tags = [ "production" ];
  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://www.keybase.io/";
    description = "Keybase official command-line utility and service";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ avaq np rvolosatovs Br1ght0ne shofius ];
    license = licenses.bsd3;
  };
}
