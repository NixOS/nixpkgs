{ stdenv, eggDerivation, fetchurl, chickenEggs }:

# Note: This mostly reimplements the default.nix already contained in
# the tarball. Is there a nicer way than duplicating code?

eggDerivation {
  src = fetchurl {
    url = "https://github.com/the-kenny/egg2nix/archive/0.2.tar.gz";
    sha256 = "051nsy30diapcl687pyfrvcyqh5h55fijqjhykra2nah30bmf0k0";
  };

  name = "egg2nix-0.2";
  buildInputs = with chickenEggs; [
    matchable http-client
  ];

  meta = {
    description = "Generate nix-expression from Chicken Scheme eggs";
    homepage = https://github.com/the-kenny/egg2nix;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
