{ stdenv, fetchurl, aterm, perl, curl, bzip2, openssl ? null
, storeDir ? "/nix/store"
, stateDir ? "/nix/var"
}:

stdenv.mkDerivation rec {
  name = "nix-0.15pre20548";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/322035/download/4/${name}.tar.bz2";
    sha256 = "1fiixfs53f8d54jadzzx2akqkdpz6ncbhixb6bkrnrgxbfjdydrr";
  };

  buildNativeInputs = [perl];
  buildInputs = [curl openssl];

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
    license = "LGPLv2+";
  };
}
