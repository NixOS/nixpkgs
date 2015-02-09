{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "exercism-${version}";

  version = "1.9.2";

  src =
    if stdenv.system == "x86_64-darwin" then
      fetchurl {
        url = "https://github.com/exercism/cli/releases/download/v${version}/exercism-mac-64bit.tgz";
        sha256 = "01ddwblq1kqxhjv8mp8r1zy6p78p6pysf1mbsyjxw1y8skfdapnp";
      }
    else if stdenv.system == "i686-darwin" then
      fetchurl {
        url = "https://github.com/exercism/cli/releases/download/v${version}/exercism-mac-32bit.tgz";
        sha256 = "0nkpnvbyi3c3dkw3149jiwil06x997wml844i9m0d6q1wblk0qdd";
      }
    else if stdenv.system == "i686-linux" then
      fetchurl {
        url = "https://github.com/exercism/cli/releases/download/v${version}/exercism-linux-32bit.tgz";
        sha256 = "0szrn28sb0w88j0kbras10wm76rsndg9j4328p01f60rabq9q3z6";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/exercism/cli/releases/download/v${version}/exercism-linux-64bit.tgz";
        sha256 = "17iah373ssd9313irmw27jq1a2gpxf8w3chjmgcgiarqfpyny5bz";
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
