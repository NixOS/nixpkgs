{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
}:

let version = "0.12pre12409"; in

stdenv.mkDerivation {
  name = "nix-${version}";
  
  src = fetchurl {
    url = "http://nixos.org/releases/nix/nix-${version}-xanlcvv3/nix-${version}.tar.bz2";
    sha256 = "499991ecd35b23eff4aba6705ce9b07c48c742390a737ca384c3ee98fd479d54";
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
