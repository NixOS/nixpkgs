{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
}:

let version = "0.12pre12178"; in

stdenv.mkDerivation {
  name = "nix-${version}";
  
  src = fetchurl {
    url = "http://nixos.org/releases/nix/nix-${version}-ncl8zjnw/nix-${version}.tar.bz2";
    sha256 = "7a5cc47272a56035bb949b32a41e7a42cfdee271334a4f12e48c96362ebd7697";
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
