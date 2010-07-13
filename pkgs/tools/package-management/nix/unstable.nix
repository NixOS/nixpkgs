{ stdenv, fetchurl, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.16pre22412";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/479753/download/4/${name}.tar.bz2";
    sha256 = "a2f49031500f1755152387a372e369a557cdc179839f67bdc9f561e47ed93ebf";
  };

  buildNativeInputs = [ perl ];
  buildInputs = [ curl openssl ];

  configureFlags =
    ''
      --with-store-dir=${storeDir} --localstatedir=${stateDir}
      --with-bzip2=${bzip2}
      --disable-init-state
      CFLAGS=-O3 CXXFLAGS=-O3
    '';

  crossAttrs = {
    configureFlags =
      ''
        --with-store-dir=${storeDir} --localstatedir=${stateDir}
        --with-bzip2=${bzip2.hostDrv}
        --disable-init-state
        CFLAGS=-O3 CXXFLAGS=-O3
      '';
    doCheck = false;
  };

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}
