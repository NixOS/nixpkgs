{ stdenv, fetchFromGitHub, make, libobjc, libffi }:

stdenv.mkDerivation rec {
  name = "gnustep-base-${version}";
  version = "0.1";

  installFlags = "DESTDIR=$(out)";

  configureFlags = [ "--disable-importing-config" ];

  buildInputs = [ libobjc make libffi ];

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "base";
    rev = "6ae70e5242e005f66175a87160b7e8e79bb46142";
    sha256 = "15z3kl0m8g63nigpl6j1ckffdwaqvmgfcgpix923wy9hm35rb9hs";
  };
}
