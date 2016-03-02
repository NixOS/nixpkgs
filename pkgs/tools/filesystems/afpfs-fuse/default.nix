{ stdenv, fetchgit, libgcrypt, gmp, readline, fuse }:

stdenv.mkDerivation rec {
  name = "afpfs-ng-fuse-0.8.2";

  src = fetchgit {
    url = "https://github.com/chetant/afpfs-ng.git";
    rev="1a766be39e9f4850c56220d2b18faf506c8baae1";
    sha256 = "24f246f4f695afef607ce7d262de6e13662debe0af7fd7aa0ae2bc72844209b7";
  };

  buildInputs = [ libgcrypt gmp readline fuse ];

  meta = {
    description = "FUSE AFP implementation";
    homepage = "https://sites.google.com/site/alexthepuffin/home";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
