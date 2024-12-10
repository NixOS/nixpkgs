{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "ccd2iso";
  version = "0.3";

  src = fetchurl {
    url = "mirror://sourceforge/ccd2iso/ccd2iso-${version}.tar.gz";
    sha256 = "1z000zi7hpr2h9cabj6hzf3n6a6gd6glmm8nn36v4b8i4vzbhx7q";
  };

  meta = with lib; {
    description = "CloneCD to ISO converter";
    homepage = "https://sourceforge.net/projects/ccd2iso/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.unix;
    mainProgram = "ccd2iso";
  };
}
