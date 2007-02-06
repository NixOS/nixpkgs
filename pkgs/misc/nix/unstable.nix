{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation {
  name = "nix-0.11pre7835";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.11pre7835/nix-0.11pre7835.tar.bz2;
    md5 = "e63ca3cdbbbf7efc6a09ca5e8ecc8e7a";
  };
  
  buildInputs = [perl curl];

  configureFlags = "
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --disable-init-state";

  meta = {
    description = "The Nix Deployment System";
  };
}
