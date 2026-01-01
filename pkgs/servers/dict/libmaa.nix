{
  lib,
  stdenv,
  fetchurl,
  libtool,
}:

stdenv.mkDerivation rec {
  version = "1.3.2";
  pname = "libmaa";

  src = fetchurl {
    url = "mirror://sourceforge/dict/libmaa-${version}.tar.gz";
    sha256 = "1idi4c30pi79g5qfl7rr9s17krbjbg93bi8f2qrbsdlh78ga19ar";
  };

  buildInputs = [ libtool ];
  # configureFlags = [ "--datadir=/run/current-system/share/dictd" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-truncation";

<<<<<<< HEAD
  meta = {
    description = "Provides many low-level data structures which are helpful for writing compilers";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Provides many low-level data structures which are helpful for writing compilers";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
