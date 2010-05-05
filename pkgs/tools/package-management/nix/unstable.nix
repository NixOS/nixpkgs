{ stdenv, fetchurl, aterm, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.16pre21576";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/395008/download/4/${name}.tar.bz2";
    sha256 = "1axmipk8vp9vwsq5wnhshgb0pcgbhanlxz8z2m3f5vxvixvw3i19";
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
