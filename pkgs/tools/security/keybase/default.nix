{ stdenv, lib, buildGoPackage, fetchurl, cf-private
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox, kbfs
}:

buildGoPackage rec {
  name = "keybase-${version}";
  version = "3.0.0";

  goPackagePath = "github.com/keybase/client";
  subPackages = [ "go/keybase" ];

  dontRenameImports = true;

  src = fetchurl {
    url = "https://github.com/keybase/client/archive/v${version}.tar.gz";
    sha256 = "1mxzihgd3qfahlmnfrpbg2kbixbjmkajrl964kaxmihrkx0fylvf";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox
    # Needed for OBJC_CLASS_$_NSData symbols.
    cf-private
  ];
  buildFlags = [ "-tags production" ];

  postInstall = lib.optionalString stdenv.isLinux ''
    ln -s ${kbfs}/bin/kbfsfuse           $bin/bin/kbfsfuse
    ln -s ${kbfs}/bin/git-remote-keybase $bin/bin/git-remote-keybase
  '';

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
  };
}
