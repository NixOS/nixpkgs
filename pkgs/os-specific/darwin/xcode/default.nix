{ stdenv, requireFile, xpwn }:

with stdenv.lib;

let
  osxVersion = "10.9";
in stdenv.mkDerivation rec {
  name = "xcode-${version}";
  version = "5.1";

  src = requireFile {
    name = "xcode_${version}.dmg";
    url = meta.homepage;
    sha256 = "0zkggbmsfc5w53j1ncbpayvnn1vzpyzyjjjzhawq1jjfq465bfvh";
  };

  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];
  outputs = [ "out" "toolchain" ];


  unpackCmd = let
    basePath = "Xcode.app/Contents/Developer/Platforms/MacOSX.platform";
    sdkPath = "${basePath}/Developer/SDKs";
  in ''
    ${xpwn}/bin/dmg extract "$curSrc" main.hfs > /dev/null
    ${xpwn}/bin/hfsplus main.hfs extractall "${sdkPath}" > /dev/null
  '';

  setSourceRoot = "sourceRoot=MacOSX${osxVersion}.sdk";

  patches = optional (osxVersion == "10.9") ./gcc-fix-enum-attributes.patch;

  installPhase = ''
    ensureDir "$out/share/sysroot"
    cp -a * "$out/share/sysroot/"
    ln -s "$out/share/sysroot/usr/lib" "$out/lib"
    ln -s "$out/share/sysroot/usr/include" "$out/include"

    ensureDir "$toolchain"
    pushd "$toolchain"
    ${xpwn}/bin/hfsplus "$(dirs +1)/../main.hfs" extractall \
      Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr \
      > /dev/null
    popd
  '';

  meta = {
    homepage = "https://developer.apple.com/downloads/";
    description = "Apple's XCode SDK";
    license = stdenv.lib.licenses.unfree;
  };
}
