{ stdenv, fetchurl, aterm, db4, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
, supportOldDBs ? true
, nameSuffix ? ""
, patches ? []
}:

stdenv.mkDerivation rec {
  name = "nix-0.13pre17232${nameSuffix}";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/75293/download/4/${name}.tar.bz2";
    sha256 = "aaea96d6dd87f8cceb2973e561d1cd0ca1beeaa0384eb91f4db09ac75d42148f";
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
