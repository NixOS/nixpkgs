{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
}:

stdenv.mkDerivation {
  name = "nix-0.13pre15047";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/13105/download/1/nix-0.13pre15047.tar.bz2;
    sha256 = "1dce821bd14743169744da9514c08f6c3bba45f13d780e7c3e368e971d1281fb";
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
