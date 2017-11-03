{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig
, gnutls, libite, libconfuse }:

let
  version = "2.1";
in
stdenv.mkDerivation {
  name = "inadyn-${version}";

  src = fetchurl {
    url = "https://github.com/troglobit/inadyn/releases/download/v${version}/inadyn-${version}.tar.xz";
    sha256 = "1b5khr2y5q1x2mn08zrnjf9hsals4y403mhsc1s7016w3my9lqw7";
  };

  patches = [
    ./remove-unused-macro.patch
    (fetchpatch {
      url = "https://github.com/troglobit/inadyn/commit/ed3a7761015441b5d5cacd691b7aa114da048bef.patch";
      sha256 = "1passghmjd7gmrfcqkfqw9lvg8l22s91nm65ys3n3rylzsgaaq8i";
     })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gnutls libite libconfuse ];

  meta = {
    homepage = http://inadyn.sourceforge.net/;
    description = "Free dynamic DNS client";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
