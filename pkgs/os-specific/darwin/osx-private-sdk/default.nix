{ stdenv, fetchFromGitHub, python, osx_sdk }:

let
  sdkVersion = "10.9";
in stdenv.mkDerivation {
  name = "PrivateMacOSX${sdkVersion}.sdk";

  src = fetchFromGitHub {
    owner  = "copumpkin";
    repo   = "OSXPrivateSDK";
    rev    = "bde9cba13e6ae62a8e4e0f405008ea719526e7ad";
    sha256 = "1vj3fxwp32irxjk987p7a223sm5bl5rrlajcvgy69k0wb0fp0krc";
  };

  buildInputs = [ python ];

  configurePhase = "true";

  buildPhase = ''
    python PrivateSDK.py -i ${osx_sdk}/Developer/SDKs/MacOSX${sdkVersion}.sdk -o PrivateMacOSX${sdkVersion}.sdk
  '';

  installPhase = ''
    mkdir -p $out/Developer/SDKs/
    mv PrivateMacOSX${sdkVersion}.sdk $out/Developer/SDKs
  '';

  meta = with stdenv.lib; {
    description = "A private Mac OS ${version} SDK, suitable for building many of Apple's open source releases";
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.unfree;
  };
}