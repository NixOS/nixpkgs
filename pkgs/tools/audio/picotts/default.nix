{ stdenv, fetchFromGitHub, autoconf, automake, libtool, popt }:

stdenv.mkDerivation {
  name = "picotts-unstable-2018-10-19";
  src = fetchFromGitHub {
    repo = "picotts";
    owner = "naggety";
    rev = "2f86050dc5da9ab68fc61510b594d8e6975c4d2d";
    sha256 = "1k2mdv9llkh77jr4qr68yf0zgjqk87np35fgfmnc3rpdp538sccl";
  };
  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ libtool popt ];
  sourceRoot = "source/pico";
  preConfigure = "./autogen.sh";
  meta = {
    description = "Text to speech voice sinthesizer from SVox.";
    homepage = "https://github.com/naggety/picotts";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.canndrew ];
    platforms = stdenv.lib.platforms.linux;
  };
}


