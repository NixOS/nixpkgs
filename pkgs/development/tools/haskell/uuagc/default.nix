{stdenv, fetchurl, ghc, uulib}:

#as long as cabal does not allow to specify which package.conf to use we create a wrapper

let {
  uulibGHC = (import ../../../compilers/ghc-wrapper) {
    libraries = [ uulib ];
    inherit stdenv ghc;
  };

  body = stdenv.mkDerivation {
    name = "uuagc-0.9.1";
    src = fetchurl {
      url = http://nix.cs.uu.nl/dist/tarballs/uuagc-0.9.1-src.tar.gz;
      md5 = "0f29cad75bd759696edc61c24d1a5db9";
    };
    buildInputs = [uulibGHC];
  };
}
