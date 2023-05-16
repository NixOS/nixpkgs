<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, fetchpatch
, zlib
}:
=======
{ lib, stdenv, fetchurl, zlib }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "gnushogi";
  version = "1.4.2";
<<<<<<< HEAD

  src = fetchurl {
    url = "mirror://gnu/gnushogi/${pname}-${version}.tar.gz";
    hash = "sha256-HsxIqGYwPGNlJVKzJdaF5+9emJMkQIApGmHZZQXVKyk=";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/gnushogi/1.4.2-7/debian/patches/01-make-dont-ignore";
      hash = "sha256-Aw0zfH+wkj+rQQzKIn6bSilP76YIO27FwJ8n1UzG6ow=";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/g/gnushogi/1.4.2-7/debian/patches/globals";
      hash = "sha256-wZJBPMYSz4n1kOyLmR9QOp70650R9xXQUWD5hvaMRok=";
    })
  ];

  buildInputs = [ zlib ];

=======
  buildInputs = [ zlib ];

  src = fetchurl {
    url = "mirror://gnu/gnushogi/${pname}-${version}.tar.gz";
    sha256 = "0a9bsl2nbnb138lq0h14jfc5xvz7hpb2bcsj4mjn6g1hcsl4ik0y";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "GNU implementation of Shogi, also known as Japanese Chess";
    homepage = "https://www.gnu.org/software/gnushogi/";
    license = licenses.gpl3;
    maintainers = [ maintainers.ciil ];
    platforms = platforms.unix;
  };
}
