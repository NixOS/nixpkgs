{ lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gnupg,
  substituteAll,
  darwin,
}:

let
  # Reasoning for the inherited apple_sdk.frameworks:
  # 1. specific compiler errors about: AVFoundation, AudioToolbox, MediaToolbox
  # 2. the rest are added from here:
  #    https://github.com/keybase/client/blob/68bb8c893c5214040d86ea36f2f86fbb7fac8d39/go/chat/attachments/preview_darwin.go#L7
  # cgo LDFLAGS: -framework AVFoundation -framework CoreFoundation \
  #              -framework ImageIO -framework CoreMedia \
  #              -framework Foundation -framework CoreGraphics -lobjc
  #  with the exception of CoreFoundation, due to the warning in:
  #  https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/darwin/apple-sdk/frameworks.nix#L25
  inherit (darwin.apple_sdk.frameworks)  AVFoundation AudioToolbox ImageIO
    CoreMedia Foundation CoreGraphics MediaToolbox;
in
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
