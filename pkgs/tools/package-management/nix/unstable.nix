{ stdenv, fetchurl, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.16pre21748";

  src = fetchurl {
    url = http://hydra.nixos.org/build/405917/download/4/nix-0.16pre21741.tar.bz2;
    sha256 = "048a9d0658906a5f344f27a0ba39c0a4d926666cef9f4e93a35f73607dd0e947";
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

  doCheck = true;

  meta = {
    description = "The Nix Deployment System";
    homepage = http://nixos.org/;
    license = "LGPLv2+";
  };
}
