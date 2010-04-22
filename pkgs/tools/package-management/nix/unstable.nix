{ stdenv, fetchurl, aterm, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.15pre20612";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/325045/download/4/${name}.tar.bz2";
    sha256 = "a0fecb2d9cced473880649d7ee6448688d63416fb2e26bdbadec069e5b619bce";
  };

  buildNativeInputs = [ perl ];
  buildInputs = [ curl openssl ];

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
    license = "LGPLv2+";
  };
}
