{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

let version = "0.11pre9692"; in

stdenv.mkDerivation {
  name = "nix-${version}";
  
  src = fetchurl {
    url = "http://nix.cs.uu.nl/dist/nix/nix-${version}/nix-${version}.tar.bz2";
    md5 = "35c0bc68b81d20c7fb925bcf8faf4827";
  };

  buildInputs = [perl curl openssl];

  configureFlags = "
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --disable-init-state";

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nix.cs.uu.nl/;
    license = "LGPL";
  };
}
