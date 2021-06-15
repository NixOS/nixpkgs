{ lib, stdenv, fetchurl, libgpgerror, libgcrypt, libassuan, libksba, pth, openldap
, libiconv}:

stdenv.mkDerivation rec {
  name = "dirmngr-1.1.1";
  src = fetchurl {
    url = "mirror://gnupg/dirmngr/${name}.tar.bz2";
    sha256 = "1zz6m87ca55nq5f59hzm6qs48d37h93il881y7d0rf2d6660na6j";
  };
  buildInputs = [ libgpgerror libgcrypt libassuan libksba
                  pth openldap libiconv ];

  meta = {
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
