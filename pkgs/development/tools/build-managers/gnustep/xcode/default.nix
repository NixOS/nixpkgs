{ stdenv, fetchgit, gnustep-make, Foundation, libobjc }:

stdenv.mkDerivation rec {
  name = "xcode-${version}";
  version = "1.0";

  makeFlags = "messages=yes";

  installFlags = "DESTDIR=$(out)";

  __impureHostDeps = [
    "/System/Library/PrivateFrameworks/UIFoundation.framework/Versions/A/UIFoundation"
    "/usr/lib/libextension.dylib"
  ];

  buildInputs = [ gnustep-make Foundation libobjc ];

  src = fetchgit {
    url = "https://github.com/gnustep/xcode";
    rev = "cc5016794e44f9998674120a5e4625aa09ca455a";
    sha256 = "85420f3f61091b2e4548cf5e99d886cb9c72cf07b8b9fae3eebc87e7b6b7e54a";
  };
}
