{ stdenv, fetchurl, bash, findutils, gawk, grep, sed, tar }:


stdenv.mkDerivation rec {
  pname = "tmpreaper";
  version = "1.6.17";
  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_${version}.tar.gz";
    sha256 = "1ca94d156eb68160ec9b6ed8b97d70fbee996de21437f0cf7d0c3b46709fecbc";;
  };

  meta = {
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    homepage = "https://packages.debian.org/sid/tmpreaper";
    description = "Clean up files in directories based on their age";
    license = "GPL-2.0-only";
  };

  buildInputs = [ bash findutils gawk grep sed tar ];
}
