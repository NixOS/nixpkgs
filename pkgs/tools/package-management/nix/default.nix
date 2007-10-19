{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation {
  name = "nix-0.10.1";
  
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/nix/nix-0.10.1/nix-0.10.1.tar.bz2;
    md5 = "22dc0c024ca5bb477da0b38ba834dbf2";
  };
  
  buildInputs = [perl curl];

  configureFlags = "
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bdb=${db4} --with-bzip2=${bzip2}
    --disable-init-state";

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nix.cs.uu.nl/;
    license = "GPL";
  };
}
