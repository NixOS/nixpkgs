{ stdenv, fetchurl, aterm, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.14pre18592";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/156376/download/4/${name}.tar.bz2";
    sha256 = "5f0d9612a5d06176a3f0a45b16155c43cbf94a2b22849030864de276cee7f9a8";
  };

  buildInputs = [perl curl openssl];

  configureFlags = ''
    --with-store-dir=${storeDir} --localstatedir=${stateDir}
    --with-aterm=${aterm} --with-bzip2=${bzip2}
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
