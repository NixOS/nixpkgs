{ stdenv, fetchurl, aterm, perl, curl, bzip2, sqlite, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.15pre20550";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/322096/download/4/${name}.tar.bz2";
    sha256 = "62009e1111a282d2b3ab8e57ceefe7b9574a7d208c4da19830066c10e0e999dc";
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
