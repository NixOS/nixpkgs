{ stdenv, fetchurl, aterm, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.14";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/281118/download/4/${name}.tar.bz2";
    sha256 = "7df3dd52a7a42354e845302665c3e1f67af287f9cca2bda67f8abb724e52c519";
  };

  buildInputs = [ perl curl openssl ];

  configureFlags =
    ''
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
