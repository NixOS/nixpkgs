{ stdenv, fetchurl, e2fsprogs }:

stdenv.mkDerivation rec {
  pname = "tmpreaper";
  version = "1.6.17";
  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_${version}.tar.gz";
    sha256 = "1ca94d156eb68160ec9b6ed8b97d70fbee996de21437f0cf7d0c3b46709fecbc";
  };

  buildInputs = [ e2fsprogs.dev ];

  meta = {
    platforms = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-darwin"];
    homepage = "https://packages.debian.org/sid/tmpreaper";
    description = "Clean up files in directories based on their age";
    license = "lib.licenses.gpl2Only";
  };
}
