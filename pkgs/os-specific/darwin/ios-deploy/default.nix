{ lib, stdenvNoCC, rsync, fetchFromGitHub }:

# Note this is impure, using system XCode to build ios-deploy. We
# should have a special flag for users to enable this.

let version = "1.12.2";
in stdenvNoCC.mkDerivation {
  pname = "ios-deploy";
  inherit version;
  src = fetchFromGitHub {
    owner = "ios-control";
    repo = "ios-deploy";
    rev = version;
    sha256 = "082w7j490khfpbv1diwrjixjbg9g93wdr2khyzdhv8xmzzwq4lad";
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
