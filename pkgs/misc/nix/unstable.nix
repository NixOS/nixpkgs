{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation {
  name = "nix-0.11pre7782";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.11pre7782/nix-0.11pre7782.tar.bz2;
    md5 = "f86a913d6f672342deba6fb3742a4c61";
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
