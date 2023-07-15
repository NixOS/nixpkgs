{ lib, stdenvNoCC, rsync, fetchFromGitHub }:

# Note this is impure, using system XCode to build ios-deploy. We
# should have a special flag for users to enable this.

let version = "1.11.0";
in stdenvNoCC.mkDerivation {
  pname = "ios-deploy";
  inherit version;
  src = fetchFromGitHub {
    owner = "ios-control";
    repo = "ios-deploy";
    rev = version;
    sha256 = "0hqwikdrcnslx4kkw9b0n7n443gzn2gbrw15pp2fnkcw5s0698sc";
  };
  nativeBuildInputs = [ rsync ];
  buildPhase = ''
    LD=$CC
    tmp=$(mktemp -d)
    ln -s /usr/bin/xcodebuild $tmp
    export PATH="$PATH:$tmp"
    xcodebuild -configuration Release SYMROOT=build OBJROOT=$tmp
  '';
  checkPhase = ''
    xcodebuild test -scheme ios-deploy-tests -configuration Release SYMROOT=build
  '';
  installPhase = ''
    install -D build/Release/ios-deploy $out/bin/ios-deploy
  '';
  meta = {
    platforms = lib.platforms.darwin;
    description = "Install and debug iOS apps from the command line. Designed to work on un-jailbroken devices";
    license = lib.licenses.gpl3;
  };
}
