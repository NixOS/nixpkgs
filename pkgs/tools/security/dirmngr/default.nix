{ stdenv, fetchurl, libgpgerror, libgcrypt, libassuan, libksba, openldap }:

stdenv.mkDerivation rec {
  name = "dirmngr-1.0.3";
  src = fetchurl {
    url = "mirror://gnupg/${name}.tar.bz2";
    sha256 = "03f54582caxgwjdv1b71azyk612a738ckgk2k05bmg466r1cw8jd";
  };

  buildInputs = [ libgpgerror libgcrypt libassuan libksba openldap ];
}
