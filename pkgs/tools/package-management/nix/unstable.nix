{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
}:

stdenv.mkDerivation {
  name = "nix-0.13pre14693";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/6410/download/1/nix-0.13pre14693.tar.bz2;
    sha256 = "1164bae4251bda7d47da7eb7ed7ec1407c80d39cb6bc08c2a6281de086f04036";
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
