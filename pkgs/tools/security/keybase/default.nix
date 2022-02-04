{ stdenv, substituteAll, lib, buildGoModule, fetchFromGitHub
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox, gnupg
}:

buildGoModule rec {
  pname = "keybase";
  version = "5.9.1";

  modRoot = "go";
  subPackages = [ "kbnm" "keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    sha256 = "sha256-WAI/rl6awVLbXqdqYAq8fyABAO2qet+GYucuiwClylI=";
  };
  vendorSha256 = "sha256-ckAnSSSEF00gbgxnPAi2Pi8TNu3nmAahK7TP6HnfmNo=";

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
    maintainers = with maintainers; [ avaq carlsverre np rvolosatovs Br1ght0ne shofius ];
    license = licenses.bsd3;
  };
}
