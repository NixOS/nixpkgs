{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation {
  name = "nix-0.11pre8349";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.11pre8349/nix-0.11pre8349.tar.bz2;
    md5 = "5f09f4986399b60e35d1815d9c003a2e";
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
