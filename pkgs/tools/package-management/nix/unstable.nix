{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
}:

stdenv.mkDerivation {
  name = "nix-0.13pre13641";
  
  src = fetchurl {
    url = http://hydra.nixos.org/download/546/1/nix-0.13pre13641.tar.bz2;
    sha256 = "83936327ed7cfa6e6a103764c3f43c780b2727ed804721200811ba999c31c7e1";
  };

  buildInputs = [perl curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bzip2=${bzip2}
    ${if supportOldDBs then "--with-bdb=${db4}" else "--disable-old-db-compat"}
    --disable-init-state
  '';

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPL";
  };
}
