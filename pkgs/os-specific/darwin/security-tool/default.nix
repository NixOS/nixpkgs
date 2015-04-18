{ stdenv, fetchurl, osx_private_sdk }:

stdenv.mkDerivation rec {
	version = "55115";
  name    = "SecurityTool-${version}";

  src = fetchurl {
    url = "http://opensource.apple.com/tarballs/SecurityTool/SecurityTool-${version}.tar.gz";
    sha256 = "0apcz4vy2z5645jhrs60wj3w27mncjjqv42h5lln36g6qs2n9113";
  };

  configurePhase = "";

  # Someday we shall purge this impurity!
  buildPhase = ''
    /usr/bin/xcodebuild SDKROOT=${osx_private_sdk}/Developer/SDKs/PrivateMacOSX10.9.sdk/
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp build/Release/security $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Command line interface to Mac OS X keychains and Security framework";
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apsl20;
  };
}