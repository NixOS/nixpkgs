{ stdenv, lib, buildGoPackage, fetchFromGitHub
, AVFoundation ? null, AudioToolbox ? null, ImageIO ? null, CoreMedia ? null
, Foundation ? null, CoreGraphics ? null, MediaToolbox ? null }:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "2.5.0";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner  = "keybase";
    repo   = "client";
    rev    = "v${version}";
    sha256 = "0fa55nizld8q0szhlpsf75ifb53js3crh98xmf8mn4bvms7d0x09";
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
