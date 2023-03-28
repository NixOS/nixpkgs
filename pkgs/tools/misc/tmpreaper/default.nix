{ lib, stdenv, fetchurl, e2fsprogs }:

stdenv.mkDerivation rec {
  pname = "tmpreaper";
  version = "1.6.17";
  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_${version}.tar.gz";
    sha256 = "1ca94d156eb68160ec9b6ed8b97d70fbee996de21437f0cf7d0c3b46709fecbc";
  };

  nativeBuildInputs = [ e2fsprogs.dev ];

  meta = with lib; {
    description = "Clean up files in directories based on their age";
    homepage = "https://packages.debian.org/sid/tmpreaper";
    license = "lib.licenses.gpl2Only";
    platforms = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ mar-jac ];
  };
}
