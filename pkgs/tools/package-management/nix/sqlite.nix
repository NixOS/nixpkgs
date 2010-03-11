{ stdenv, fetchurl, aterm, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.15pre20563";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/322387/download/4/${name}.tar.bz2";
    sha256 = "20d2d7f231c2c92e68c8d828292ecde4e3858a95965dfc6b7066feb24659541e";
  };

  buildInputs = [perl curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bzip2=${bzip2} --with-sqlite=${sqlite}
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
