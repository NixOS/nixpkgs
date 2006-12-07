{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation {
  name = "nix-0.11pre7273";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.11pre7273/nix-0.11pre7273.tar.bz2;
    md5 = "852df180cc2f9384d4e4780a163c2767";
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
