{stdenv, platform, toolchain, xcbuild, writeText}:

let

AbstractAssetCatalog = {
    Type = "FileType";
    Identifier = "folder.abstractassetcatalog";
    BasedOn = "wrapper";

    UTI = "com.apple.dt.abstractassetcatalog";
    IsTransparent = "NO";
};

in

stdenv.mkDerivation {
  name = "Xcode.app";
  buildInputs = [ xcbuild ];
  buildCommand = ''
    mkdir -p $out/Contents/Developer/Library/Xcode/Specifications/
    cp ${xcbuild}/Library/Xcode/Specifications/* $out/Contents/Developer/Library/Xcode/Specifications/

    plutil -convert xml1 ${writeText "folder.abstractassetcatalog" (builtins.toJSON AbstractAssetCatalog)} -o $out/Contents/Developer/Library/Xcode/Specifications/folder.abstractassetcatalog.xcspec

    mkdir -p $out/Contents/Developer/Platforms/
    cd $out/Contents/Developer/Platforms/
    ln -s ${platform}

    mkdir -p $out/Contents/Developer/Toolchains/
    cd $out/Contents/Developer/Toolchains/
    ln -s ${toolchain}
  '';
}
