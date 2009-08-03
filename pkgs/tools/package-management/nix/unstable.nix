{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
}:

stdenv.mkDerivation rec {
  name = "nix-0.13pre16562";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/55767/download/4/${name}.tar.bz2";
    sha256 = "c82b8b81f624b73487b5c638b7a6b0ce3b714a748495f1f722042b26dfb8a474";
  };

  buildInputs = [perl curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bzip2=${bzip2}
    ${if supportOldDBs then "--with-bdb=${db4}" else "--disable-old-db-compat"}
    --disable-init-state
  '';

  doCheck = true;

  passthru = { inherit aterm; };

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}
