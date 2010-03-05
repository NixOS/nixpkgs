{ stdenv, fetchurl, aterm, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.15pre20408";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/310943/download/4/${name}.tar.bz2";
    sha256 = "f94d95981db9093604c843225aa9f9dfe82d3352cb1ecba92de03d117d9bb4b9";
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
