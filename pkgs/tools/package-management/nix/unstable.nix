{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
}:

stdenv.mkDerivation {
  name = "nix-0.13pre14683";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/5836/download/1/nix-0.13pre14683.tar.bz2;
    sha256 = "74aaada09cff1c0db130a5ee7c8f495b31e2e9b072bf9395035689219a45f100";
  };

  buildInputs = [perl curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bzip2=${bzip2}
    ${if supportOldDBs then "--with-bdb=${db4}" else "--disable-old-db-compat"}
    --disable-init-state
  '';

  passthru = { inherit aterm; };

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}
