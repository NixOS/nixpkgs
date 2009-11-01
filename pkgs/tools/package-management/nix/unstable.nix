{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
, nameSuffix ? ""
, patches ? []
}:

stdenv.mkDerivation rec {
  name = "nix-0.13pre17922${nameSuffix}";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/105957/download/4/${name}.tar.bz2";
    sha256 = "11735f2d01ed1c4a7dd345690cd6bbfec175626a6bf2c0d76a27da3c5f51c187";
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

  inherit patches;
}
