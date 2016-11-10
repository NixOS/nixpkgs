{ stdenv, platform, toolchain, xcbuild, writeText }:

stdenv.mkDerivation {
  name = "Xcode.app";
  buildInputs = [ xcbuild ];
  buildCommand = ''
    mkdir -p $out/Contents/Developer/Library/Xcode/Specifications/
    cp ${xcbuild}/Library/Xcode/Specifications/* $out/Contents/Developer/Library/Xcode/Specifications/

    mkdir -p $out/Contents/Developer/Platforms/
    cd $out/Contents/Developer/Platforms/
    ln -s ${platform}

    mkdir -p $out/Contents/Developer/Toolchains/
    cd $out/Contents/Developer/Toolchains/
    ln -s ${toolchain}
  '';
}
