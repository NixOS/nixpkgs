{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation {
  name = "nix-0.11pre8133";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.11pre8133/nix-0.11pre8133.tar.bz2;
    md5 = "33c28fcd97d5ae64e9219897b36cc6e4)";
  };
  
  buildInputs = [perl curl openssl];

  configureFlags = "
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --disable-init-state";

  meta = {
    description = "The Nix Deployment System";
  };
}
