{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "exercism-${version}";

  version = "1.6.2";

  src =
    if stdenv.system == "x86_64-darwin" then
      fetchurl {
        url = "https://github.com/exercism/cli/releases/download/v${version}/exercism-darwin-amd64.tgz";
        sha256 = "1w9jw52nhb5mlcj6ampzwjscdr9rja5mdn5ga2r4z2qzsqzwkpm2";
      }
    else if stdenv.system == "i686-darwin" then
      fetchurl {
        url = "https://github.com/exercism/cli/releases/download/v${version}/exercism-darwin-386.tgz";
        sha256 = "1g5cy53mrdzq047b8hlkjrkc4bp7yhipvhf4lnw0x2jr50z73bzd";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "https://github.com/exercism/cli/releases/download/v1.6.2/exercism-linux-386.tgz";
        sha256 = "1akdggla9kn7v4dwkyz63bp84dihcgyph546zskiyh9bz67l5liz";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/exercism/cli/releases/download/v1.6.2/exercism-linux-amd64.tgz";
        sha256 = "00kp0r9xy9bw9b2854csy35pk9sxvbivxmwiy97wl9gh0acva5ng";
      }
    else throw "Platform: ${stdenv.system} not supported!";

  buildPhase = "";

  setSourceRoot = "sourceRoot=./";

  installPhase = ''
    mkdir -p $out/bin
    cp -a exercism $out/bin
  '';

  meta = {
    description = "A Go based command line tool for exercism.io";
    homepage    = http://exercism.io;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.wjlroe ];
  };
}
