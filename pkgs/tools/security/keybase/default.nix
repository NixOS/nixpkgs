{ stdenv, lib, buildGoPackage, fetchFromGitHub
, AVFoundation ? null, AudioToolbox ? null, ImageIO ? null, CoreMedia ? null
, Foundation ? null, CoreGraphics ? null, MediaToolbox ? null }:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "2.7.3";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner  = "keybase";
    repo   = "client";
    rev    = "v${version}";
    sha256 = "1sw6v3vf544vp8grw8p287cx078mr9v0v1wffcj6f9p9shlwj7ic";
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
