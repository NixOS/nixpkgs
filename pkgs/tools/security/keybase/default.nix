{ stdenv, substituteAll, lib, buildGoModule, fetchFromGitHub
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox, gnupg
}:

buildGoModule rec {
  pname = "keybase";
  version = "6.0.2";

  modRoot = "go";
  subPackages = [ "kbnm" "keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    sha256 = "sha256-JiYufEsoj/98An2qKdm/Uu4YHJr6ttc/VHn4kMgkuwI=";
  };
  vendorSha256 = "sha256-D8b/pvmBGCnaRuf92FYgRcSSbN59Yu0CHKxAybdYjS4=";

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
