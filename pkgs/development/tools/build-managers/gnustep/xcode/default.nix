{ stdenv, fetchFromGitHub, gnustep-make, gobjc, gnustep-base }:

stdenv.mkDerivation rec {
  name = "xcode-${version}";
  version = "0.1";

  makeFlags = "messages=yes";

  installFlags = "DESTDIR=$(out)";

  buildInputs = [ gnustep-make gnustep-base gobjc ];

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "xcode";
    rev = "cc5016794e44f9998674120a5e4625aa09ca455a";
    sha256 = "85420f3f61091b2e4548cf5e99d886cb9c72cf07b8b9fae3eebc87e7b6b7e54a";
  };
}
