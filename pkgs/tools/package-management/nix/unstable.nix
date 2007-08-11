{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation {
  name = "nix-0.11pre8816";
  
  src =   
	fetchurl {
		url = http://nix.cs.uu.nl/dist/nix/nix-unstable-latest/nix-0.11pre9063.tar.bz2;
		sha256 = "0fxsvam0ihzcfg694d28d6b3vkx5klh25jvf3y5igyyqszmmhnxj";
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
