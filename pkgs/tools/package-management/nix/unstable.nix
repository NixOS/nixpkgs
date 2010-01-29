{ stdenv, fetchurl, aterm, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.14pre19730";
  
  src = fetchurl {
    url = "http://hydra.nixos.org/build/275242/download/4/${name}.tar.bz2";
    sha256 = "8359230264e1b96bfadf2c719f98f95dc08990d111854c18abb8a5e86092ec75";
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
