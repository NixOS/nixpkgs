{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "which";
  version = "2.21";

  src = fetchurl {
    url = "mirror://gnu/which/which-${version}.tar.gz";
    sha256 = "1bgafvy3ypbhhfznwjv1lxmd6mci3x1byilnnkc7gcr486wlb8pl";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.gnu.org/software/which/";
    description = "Shows the full path of (shell) commands";
    platforms = platforms.all;
    license = licenses.gpl3;
  };
}
