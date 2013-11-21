{ stdenv, libusb1, fetchgit }:


let
  rev = "85ee5eeaca59a1c92659c3f49b148b0447d78f16";
in

  stdenv.mkDerivation {
    name = "alienfx-1.0.0";
    src = fetchgit {
      inherit rev;
      url = https://github.com/tibz/alienfx.git;

      sha256 = "47501a3b4e08d39edee4cd829ae24259a7e740b9798db76b846fa872989f8fb1";
      };

    buildInputs = [ libusb1 ];
# This might only work for 64-bit.
    buildPhase = ''
g++ -lusb-1.0 -o alienfx alienfx.cpp
'';
# This is a total hack. Please let me know the proper way to do this.
    installPhase = ''
mkdir -p $out/bin
install -m 4755 alienfx $out/bin/alienfx
'';
  }
